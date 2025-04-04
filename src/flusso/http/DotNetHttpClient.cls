/*------------------------------------------------------------------------
  File        : DotNetHttpClient
  Purpose     :
  Syntax      :
  Author(s)   : arno
  Created     : Thu Jan 23 12:36:36 +01:00 2025
  Notes       : Copyright 2025 Flusso B.V.
                Developed under MIT License, see LICENSE file
----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.String.
using OpenEdge.Core.WidgetHandle.
using Progress.Collections.HashMap.
using Progress.Collections.HashMapIterator.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.AppError.
using System.IO.StreamReader.
using System.Net.HttpWebRequest.
using System.Net.HttpWebResponse.
using System.Net.WebHeaderCollection.
using System.Net.WebUtility.
using System.Runtime.InteropServices.Marshal.
using System.Text.Encoding.
using flusso.http.HttpRequestOptions.
using flusso.http.HttpResponse.
using flusso.http.IHttpClient.

class flusso.http.DotNetHttpClient
  implements IHttpClient:

  /*------------------------------------------------------------------------------
    Purpose: converts a .NET body to an Object
    Notes:
    @param webResponse HttpWebResponse
    @return Object
  ------------------------------------------------------------------------------*/
  method protected Progress.Lang.Object ConvertBody (webResponse as HttpWebResponse):

    // GetResponseStream returns the result body of the the Response
    var StreamReader      streamReader = new StreamReader(webResponse:GetResponseStream()).
    var ObjectModelParser jsonParser.

    var longchar body = streamReader:ReadToEnd().
    var handle   xmlBody.
    var memptr   memBody.

    // xml body
    if    webResponse:ContentType matches "*/xml*"
       or webResponse:ContentType matches "*/html*" then do:
      create x-document xmlBody.
      xmlBody:load("longchar", body, false).
      return new WidgetHandle(xmlBody, true).
    end.

    // json body
    if webResponse:ContentType matches "*/json*" then do:
      jsonParser = new ObjectModelParser().
      return cast(jsonParser:Parse(body), JsonConstruct).
    end.

    // text body
    if    webResponse:ContentType matches "*/plain*"
       or webResponse:ContentType begins "text/" then
      return new String(body).

    // other
    do on error undo, throw:
      set-size(memBody) = length(body, "raw") + 1.
      put-string(memBody, 1) = body.
      return new OpenEdge.Core.Memptr(memBody).

      finally:
        set-size(memBody) = 0.
      end finally.
    end.

  end method.

  /*------------------------------------------------------------------------------
    Purpose: Converts a HttpWebResponse to HttpResponse
    Notes:
    @param webResponse HttpWebResponse
    @return HttpResponse
  ------------------------------------------------------------------------------*/
  method protected HttpResponse ConvertResponse (webResponse as HttpWebResponse):

    var HttpResponse        response = new HttpResponse().
    var WebHeaderCollection headers  = webResponse:Headers.

    var int i.

    response:Status      = webResponse:StatusCode:value__.
    response:Reason      = webResponse:StatusDescription.
    response:ContentType = webResponse:ContentType.
    response:Body        = this-object:ConvertBody(webResponse).

    // copy the headers
    do i = 0 to (headers:Count - 1):
      response:Headers:Add (new String(headers:GetKey(i)),
                            new String(headers:Get(i))).
    end.

    return response.

  end method.

  /*------------------------------------------------------------------------------
    Purpose:
    Notes:
  ------------------------------------------------------------------------------*/
  method private HttpResponse ExecuteRequest (url            as char,
                                              requestOptions as HttpRequestOptions,
                                              data           as Progress.Lang.Object,
                                              method         as char):

    var HttpWebRequest                  request.
    var HttpWebResponse                 webResponse.
    var HashMapIterator<String, String> iterator.
    var character                       requestUri.
    var "System.Byte[]"                 bytes.
    var System.IO.Stream                ioStream.

    requestUri = this-object:GetRequestUri(url, requestOptions:QueryParameters).
    request    = HttpWebRequest:CreateHttp(requestUri).

    request:Method = method.

    if valid-object(requestOptions) then do:
      iterator = cast(requestOptions:Headers:GetIterator(), HashMapIterator<String, String>).

      do while iterator:MoveNext():
        request:Headers:Add(iterator:Current:Key:ToString(),
                            iterator:Current:Value:ToString()).
      end.
    end.

    if valid-object(data) then do:
      bytes    = this-object:GetBodyInBytes(data).
      ioStream = request:GetRequestStream().
      ioStream:Write(bytes, 0, bytes:Length).
      ioStream:Close().
    end.

    webResponse = cast(request:GetResponse(), HttpWebResponse).

    return this-object:ConvertResponse(webResponse).

  end method.

  /*------------------------------------------------------------------------------
    Purpose: GET
    Notes:
    @param url Url
    @return HttpResponse
  ------------------------------------------------------------------------------*/
  method public HttpResponse Get(url as char):

    return this-object:ExecuteRequest(url, ?, ?, "GET").

  end method.

  /*------------------------------------------------------------------------------
    Purpose: GET
    Notes:
    @param url            Url
    @param requestOptions Request options
    @return HttpResponse
  ------------------------------------------------------------------------------*/
  method public HttpResponse Get(url            as char,
                                 requestOptions as HttpRequestOptions):

    return this-object:ExecuteRequest(url, requestOptions, ?, "GET").

  end method.

  /*------------------------------------------------------------------------------
    Purpose: Get the body in Bytes
    Notes:
    @param data Data
    @return Bytes array
  ------------------------------------------------------------------------------*/
  method public "System.Byte[]" GetBodyInBytes (data as Progress.Lang.Object):

    var System.IntPtr   ptr.
    var int             size.
    var "System.Byte[]" bytes.
    var memptr          mptr.
    var longchar        dataText.
    var handle          xmlHdl.

    if not valid-object(data) then
      return ?.

    case true:
      // xml
      when type-of(data, WidgetHandle) then do:
        xmlHdl   = cast(data, WidgetHandle):Value.
        // todo: encoding via x-document:encoding
        xmlHdl:save("longchar", dataText).
        bytes = Encoding:UTF8:GetBytes(dataText).
      end.

      // json
      when type-of(data, JsonConstruct) then do:
        cast(data, JsonConstruct):Write(dataText, true, "utf-8").
        bytes = Encoding:UTF8:GetBytes(dataText).
      end.

      // text
      when type-of(data, OpenEdge.Core.String) then do:
        dataText = cast(data, OpenEdge.Core.String):Value.
        bytes = Encoding:UTF8:GetBytes(dataText).
      end.

      // memptr
      when type-of(data, OpenEdge.Core.Memptr) then do on error undo, throw:
        mptr  = cast(data, OpenEdge.Core.Memptr):Value.
        size  = get-size(mptr).
        bytes = new "System.Byte[]"(size).
        ptr   = new System.IntPtr(get-pointer-value(mptr)).
        Marshal:Copy(ptr, bytes, 0, size).
        finally:
          delete object ptr.
          set-size(mptr) = 0.
        end.
      end. // Memptr

      otherwise undo, throw new AppError("Invalid body type: " + data:GetClass():TypeName).
    end case.

    return bytes.

  end method.

  /*------------------------------------------------------------------------------
    Purpose: Gets the full request url (host + query parameters)
    Notes:
    @param baseUrl         Base url
    @param queryParameters Query parameters
    @return Object
  ------------------------------------------------------------------------------*/
  method private character GetRequestUri (baseUrl as char,
                                          queryParameters as HashMap<String, String>):

    var HashMapIterator<String, String> iterator.
    var char requestUri.

    requestUri = baseUrl.

    if valid-object(queryParameters) then do:
      requestUri = baseUrl + "?".

      iterator = cast(queryParameters:GetIterator(), HashMapIterator<String, String>).
      do while iterator:MoveNext():
        requestUri += substitute("&1=&2",
                                 iterator:Current:Key:ToString(),
                                 WebUtility:UrlEncode(iterator:Current:Value:ToString()))
                    + "&".
      end.
    end.

    return right-trim(requestUri, "&").

  end method.

  /*------------------------------------------------------------------------------
    Purpose: POST
    Notes:
    @param url  Url
    @param data Body
    @return HttpResponse
  ------------------------------------------------------------------------------*/
  method public HttpResponse Post(url  as char,
                                  data as Progress.Lang.Object):

    return this-object:ExecuteRequest(url, ?, data, "POST").

  end method.

  /*------------------------------------------------------------------------------
    Purpose: POST
    Notes:
    @param url            Url
    @param data           Body
    @param requestOptions Request options
    @return HttpResponse
  ------------------------------------------------------------------------------*/
  method public HttpResponse Post(url            as char,
                                  data           as Progress.Lang.Object,
                                  requestOptions as HttpRequestOptions):

    return this-object:ExecuteRequest(url, requestOptions, data, "POST").

  end method.

  /*------------------------------------------------------------------------------
    Purpose: PUT
    Notes:
    @param url  Url
    @param data Body
    @return HttpResponse
  ------------------------------------------------------------------------------*/
  method public HttpResponse Put(url  as char,
                                 data as Progress.Lang.Object):

    return this-object:ExecuteRequest(url, ?, data, "PUT").

  end method.

  /*------------------------------------------------------------------------------
    Purpose: PUT
    Notes:
    @param url            Url
    @param data           Body
    @param requestOptions Request options
    @return HttpResponse
  ------------------------------------------------------------------------------*/
  method public HttpResponse Put (url            as char,
                                  data           as Progress.Lang.Object,
                                  requestOptions as HttpRequestOptions):

    return this-object:ExecuteRequest(url, requestOptions, data, "PUT").

  end method.

  /*------------------------------------------------------------------------------
    Purpose: DELETE
    Notes:
    @param url  Url
    @param data Body
    @return HttpResponse
  ------------------------------------------------------------------------------*/
  method public HttpResponse Delete(url  as char,
                                    data as Progress.Lang.Object):

    return this-object:ExecuteRequest(url, ?, data, "DELETE").

  end method.

  /*------------------------------------------------------------------------------
    Purpose: DELETE
    Notes:
    @param url            Url
    @param data           Body
    @param requestOptions Request options
    @return HttpResponse
  ------------------------------------------------------------------------------*/
  method public HttpResponse Delete(url            as char,
                                    data           as Progress.Lang.Object,
                                    requestOptions as HttpRequestOptions):

    return this-object:ExecuteRequest(url, requestOptions, data, "DELETE").

  end method.

end class.
