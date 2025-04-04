
 /*------------------------------------------------------------------------
    File        : AblHttpClient
    Purpose     :
    Syntax      :
    Author(s)   : bronco / Flusso B.V.
    Created     : Thu Jan 23 12:36:36 +01:00 2025
    Notes       : Copyright (c) 2025 Flusso B.V. (MIT license, see attached LICENSE file)
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.String.
using OpenEdge.Net.HTTP.ClientBuilder.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.IHttpClientLibrary.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.Lib.ClientLibraryBuilder.
using OpenEdge.Net.HTTP.RequestBuilder.
using Progress.Collections.HashMap.
using Progress.Collections.HashMapIterator.
using flusso.http.HttpRequestOptions.
using flusso.http.HttpResponse.
using flusso.http.IHttpClient.

class flusso.http.AblHttpClient implements IHttpClient:

  var private IHttpClientLibrary httpClientLibrary.
  var private char[] protocols = ["TLSv1.2"].

  /*------------------------------------------------------------------------------
    Purpose: Constructor
    Notes:
  ------------------------------------------------------------------------------*/
  constructor public AblHttpClient():

    httpClientLibrary = ClientLibraryBuilder
                               :Build()
                               :SetSSLProtocols(protocols)
                               //:SetSSLCiphers(ciphers)
                               :Library.

  end constructor.

  /*------------------------------------------------------------------------------
    Purpose: GET
    Notes:
    @param url Url
    @return HttpResponse
  ------------------------------------------------------------------------------*/
  method public HttpResponse Get(url as char):
    return this-object:Get(url, ?).
  end method.  // Get

  /*------------------------------------------------------------------------------
    Purpose: GET
    Notes:
    @param url            Url
    @param requestOptions Request options
    @return HttpResponse
  ------------------------------------------------------------------------------*/
  method public HttpResponse Get(url as char, options as HttpRequestOptions):
    var RequestBuilder builder = RequestBuilder:Get(url).
    return ExecuteRequest(builder, options).
  end method.  // Get

  /*------------------------------------------------------------------------------
    Purpose: POST
    Notes:
    @param url  Url
    @param data Body
    @return HttpResponse
  ------------------------------------------------------------------------------*/
  method public HttpResponse Post(url as char, data as Progress.Lang.Object):
    return Post(url, data, ?).
  end method.  // Post

  /*------------------------------------------------------------------------------
    Purpose: POST
    Notes:
    @param url            Url
    @param data           Body
    @param requestOptions Request options
    @return HttpResponse
  ------------------------------------------------------------------------------*/
  method public HttpResponse Post(url as char, data as Progress.Lang.Object, options as HttpRequestOptions):
    var RequestBuilder builder = RequestBuilder:Post(url, data).
    return ExecuteRequest(builder, options).
  end method.  // Post

  /*------------------------------------------------------------------------------
    Purpose: PUT
    Notes:
    @param url  Url
    @param data Body
    @return HttpResponse
  ------------------------------------------------------------------------------*/
  method public HttpResponse Put(url as char, data as Progress.Lang.Object):
    return this-object:Put(url, data, ?).
  end method.  // Put

  /*------------------------------------------------------------------------------
    Purpose: PUT
    Notes:
    @param url            Url
    @param data           Body
    @param requestOptions Request options
    @return HttpResponse
  ------------------------------------------------------------------------------*/
  method public HttpResponse Put(url as char, data as Progress.Lang.Object, options as HttpRequestOptions):
    var RequestBuilder builder = RequestBuilder:Put(url, data).
    return ExecuteRequest(builder, options).
  end method.  // Put

  /*------------------------------------------------------------------------------
    Purpose: DELETE
    Notes:
    @param url  Url
    @param data Body
    @return HttpResponse
  ------------------------------------------------------------------------------*/
  method public HttpResponse Delete(url as char, data as Progress.Lang.Object):
    return this-object:Delete(url, data, ?).
  end method.  // Delete

  /*------------------------------------------------------------------------------
    Purpose: DELETE
    Notes:
    @param url            Url
    @param data           Body
    @param requestOptions Request options
    @return HttpResponse
  ------------------------------------------------------------------------------*/
  method public HttpResponse Delete(url as char, data as Progress.Lang.Object, options as HttpRequestOptions):
    var RequestBuilder builder = RequestBuilder:Put(url, data).
    return ExecuteRequest(builder, options).
  end method.  // Delete

  /*------------------------------------------------------------------------------
    Purpose: Execute the request
    Notes:
    @param builder Request builder object
    @param options Request options
    @return HttpResponse
  ------------------------------------------------------------------------------*/
  method private HttpResponse ExecuteRequest(builder as RequestBuilder, options as HttpRequestOptions):

    var IHttpRequest request.
    var IHttpResponse oeResponse.
    var HttpResponse response.
    var OpenEdge.Net.HTTP.IHttpClient client.

    response = new HttpResponse().

    this-object:ApplyOptions(builder, options).

    request = builder:Request.
    if options?:QueryParameters:Count > 0 then
      AddQueryParametersToRequest(request, options:QueryParameters).

    client = ClientBuilder
               :Build()
               :UsingLibrary(httpClientLibrary)
               :Client.

    do on error undo, throw:

      oeResponse = client:Execute(request).

      response:Status = oeResponse:StatusCode.
      response:Reason = oeResponse:StatusReason.
      response:ContentType = oeResponse:ContentType.
      response:Body = oeResponse:Entity.
      response:Headers = GetHeaders(oeResponse).

      catch err1 as Progress.Lang.Error:
        response:Status = int(err1:GetMessage(1)).
        response:Reason = substitute("&1:&2 - &3", err1:GetMessage(2), err1:GetMessage(3), err1:GetMessage(4)).
      end catch.

    end.  // do on error...

    return response.

  end method.  // ExecuteRequest

  /*------------------------------------------------------------------------------
    Purpose: Add options to the request builder
    Notes:
    @param builder Request builder object
    @param options Request options
  ------------------------------------------------------------------------------*/
  method private void ApplyOptions(builder as RequestBuilder, options as HttpRequestOptions):

    if not valid-object(options) then
      return.

    AddHeadersToRequest(builder, options).

  end method.  // ApplyOptions

  /*------------------------------------------------------------------------------
    Purpose: Add headers to the request builder
    Notes:
    @param builder Request builder object
    @param options Request options
  ------------------------------------------------------------------------------*/
  method private void AddHeadersToRequest(builder as RequestBuilder, options as HttpRequestOptions):

    var HashMapIterator<String, String> iterator.

    if not valid-object(options) then
      return.

    iterator = cast(options:Headers:GetIterator(), HashMapIterator<String, String>).
    do while iterator:MoveNext():
      builder:AddHeader(iterator:Current:Key:ToString(), iterator:Current:Value:ToString()).
    end.

  end method.  // AddHeadersToRequest

  /*------------------------------------------------------------------------------
    Purpose: Add headers to the request builder
    Notes:
    @param builder Request builder object
    @param options Request options
  ------------------------------------------------------------------------------*/
  method private void AddQueryParametersToRequest(request as IHttpRequest, queryParameters as HashMap<String, String>):

    var HashMapIterator<String, String> iterator.

    iterator = cast(queryParameters:GetIterator(), HashMapIterator<String, String>).
    do while iterator:MoveNext():
      request:URI:AddQuery(iterator:Current:Key:ToString(), iterator:Current:Value:ToString()).
    end.

  end method.  // AddQueryParametersToRequest

  /*------------------------------------------------------------------------------
    Purpose: Get headers
    Notes:
    @param oeResponse OE response object
    @return HashMap of the headers
  ------------------------------------------------------------------------------*/
  method private HashMap<String, String> GetHeaders(oeResponse as IHttpResponse):
    var HashMap<String, String> headers = new HashMap<String, String>().
    var HttpHeader[] oeHeaders.
    var int i.

    oeResponse:GetHeaders(output oeHeaders). // why???
    do i = 1 to extent(oeHeaders):
      headers:Add(new String(oeHeaders[i]:Name), new String(oeHeaders[i]:Value)).
    end.  // do i = 1 to...

    //oeResponse:
    return headers.

  end method.  // GetHeaders

end class.  // AblHttpClient
