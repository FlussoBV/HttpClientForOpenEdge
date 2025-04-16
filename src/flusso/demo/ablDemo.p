/*------------------------------------------------------------------------
  File        : ablDemo.p
  Purpose     : 
  Syntax      :
  Description : 
  Author(s)   : arno
  Created     : Tue Apr 15 16:09:42 CEST 2025
  Notes       :
----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Net.HTTP.ClientBuilder.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.RequestBuilder.
using Progress.Json.ObjectModel.JsonObject.

var longchar result.

var IHttpRequest httpRequest.
var IHttpResponse httpResponse.

// prepare request
httpRequest = RequestBuilder:Get("http://jsonplaceholder.typicode.com/todos/1")
                            :AddHeader("Accept", "application/json")
                            :Request.

// execute request
httpResponse = ClientBuilder:Build()
                            :Client
                            :Execute(httpRequest).

// get response body
cast(httpResponse:Entity, JsonObject):Write(result, true).

message httpResponse:StatusCode skip string(result) view-as alert-box title "ABL".
