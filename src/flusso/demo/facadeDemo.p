/*------------------------------------------------------------------------
  File        : facadeDemo.p
  Purpose     : 
  Syntax      :
  Description : 
  Author(s)   : arno
  Created     : Tue Apr 15 16:09:42 CEST 2025
  Notes       :
----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Json.ObjectModel.JsonObject.
using flusso.http.AblHttpClient.
using flusso.http.DotNetHttpClient.
using flusso.http.HttpClientFactory.
using flusso.http.HttpRequestOptions.
using flusso.http.HttpResponse.
using flusso.http.IHttpClient.

var longchar result.

var IHttpClient httpClient = new AblHttpClient().
//var IHttpClient httpClient = new DotNetHttpClient().
//var IHttpClient httpClient = HttpClientFactory:Get("default-http-client").

// prepare request
var HttpRequestOptions args = new HttpRequestOptions()
                                    :SetHeader("Accept", "application/json").

// execute request
var HttpResponse httpResponse = httpClient:Get("http://jsonplaceholder.typicode.com/todos/1", args).

// get response body
cast(httpResponse:Body, JsonObject):Write(result, true).

message httpResponse:Status skip string(result) skip(1)
        httpClient:GetClass():TypeName view-as alert-box title "Facade".
