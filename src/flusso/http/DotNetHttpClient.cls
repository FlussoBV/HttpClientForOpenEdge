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
using OpenEdge.Net.HTTP.HttpHeader.
using Progress.Collections.HashMapIterator.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using System.IO.StreamReader.
using System.Net.HttpWebRequest.
using System.Net.HttpWebResponse.
using System.Net.WebHeaderCollection.
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
      return cast(jsonParser:Parse(body), JsonObject).
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
    Purpose: GET
    Notes:
    @param url Url
    @return HttpResponse
  ------------------------------------------------------------------------------*/
  method public HttpResponse Get(url as char):

    return this-object:Get(url, new HttpRequestOptions()).

  end method.

  /*------------------------------------------------------------------------------
    Purpose: GET
    Notes:
    @param url     Url
    @param options Request options
    @return HttpResponse
  ------------------------------------------------------------------------------*/
  method public HttpResponse Get(url as char, options as HttpRequestOptions):

    var HttpWebRequest                  request.
    var HttpWebResponse                 webResponse.
    var HashMapIterator<String, String> iterator.

    var IIterator<KeyValuePair<String, String>> iterator.
    request = HttpWebRequest:CreateHttp(url).

    request:Method = "GET".

    if valid-object(options) then do:
      iterator = cast(options:Headers:GetIterator(), HashMapIterator<String, String>).
      request:ContentType = options:ContentType.

      iterator = options:Headers:GetIterator().

      do while iterator:MoveNext():
        request:Headers:Add(iterator:Current:Key:ToString(),
                            iterator:Current:Value:ToString()).
      end.
    end.

    webResponse = cast(request:GetResponse(), HttpWebResponse).

    return this-object:ConvertResponse(webResponse).

  end method.

  method public HttpResponse Post(url as char, data as Progress.Lang.Object):
  end method.
  
  method public HttpResponse Post(url as char, data as Progress.Lang.Object, options as HttpRequestOptions):
  end method.
  
  method public HttpResponse Put(url as char, data as Progress.Lang.Object):
  end method.
  
  method public HttpResponse Put(url as char, data as Progress.Lang.Object, options as HttpRequestOptions):
  end method.
  
  method public HttpResponse Delete(url as char, data as Progress.Lang.Object):
  end method.
  
  method public HttpResponse Delete(url as char, data as Progress.Lang.Object, options as HttpRequestOptions):
  end method.

end class.
