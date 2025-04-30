/*------------------------------------------------------------------------
  File        : DemoRunner
  Purpose     :
  Syntax      :
  Description :
  Author(s)   : arno
  Created     : Tue Apr 08 20:02:50 CEST 2025
  Notes       : Copyright 2025 Flusso B.V.
                Developed under MIT License, see LICENSE file
----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.
using flusso.factory.IConfigurable.
using flusso.http.HttpClientFactory.
using flusso.http.HttpRequestOptions.
using flusso.http.HttpResponse.
using flusso.http.IHttpClient.

class flusso.demo.DemoRunner
  implements IConfigurable:

   var private char httpClientIdentifier.
   var private char requestMethod.
   var private char requestUrl.

  /*------------------------------------------------------------------------------
    Purpose: Configure
    Notes:
  ------------------------------------------------------------------------------*/
  method public void Configure (config as JsonObject):

    httpClientIdentifier = config:GetCharacter("httpClientName").
    requestMethod        = config:GetCharacter("method").
    requestUrl           = config:GetCharacter("url").

  end method.

  /*------------------------------------------------------------------------------
    Purpose: When the response has a statuscode >= 400, throw as error
    Notes:
  ------------------------------------------------------------------------------*/
  method public void HandleError (httpResponse as HttpResponse):

    if httpResponse:Status ge 400 then
      undo, throw new AppError(substitute("&1 - &2", httpResponse:Status, httpResponse:Reason), -1).

  end method.

  /*------------------------------------------------------------------------------
    Purpose: Run
    Notes:
  ------------------------------------------------------------------------------*/
  method public void Run (nrRuns as int):

    if nrRuns eq ? or nrRuns eq 0 then
      nrRuns = 10.

    message.

    case requestMethod:
      when "GET"    then ExecuteGetDeleteRequests(nrRuns).
      when "DELETE" then ExecuteGetDeleteRequests(nrRuns).
      when "POST"   then ExecutePostPutRequests(nrRuns).
      when "PUT"    then ExecutePostPutRequests(nrRuns).
      otherwise undo, throw new AppError(substitute("request method '&1' not implemented", requestMethod), -1).
    end case.

    finally:
      message.
    end finally.

  end method.

  /*------------------------------------------------------------------------------
    Purpose: Execute a x number of GET requests
    Notes:
  ------------------------------------------------------------------------------*/
  method public void ExecuteGetDeleteRequests (nrReq as int):

    var int i, totalMsec.
    var HttpResponse httpResponse.
    var IHttpClient httpClient = HttpClientFactory:Get(httpClientIdentifier).
    var datetime-tz begin.

    // dry run
    etime(true).
    if requestMethod eq "GET" then
      httpResponse = httpClient:Get(requestUrl).
    else
      httpResponse = httpClient:Delete(requestUrl).
    this-object:HandleError(httpResponse).
    message substitute("dry : etime &1 msec~n~n~n", etime).

    begin = now.

    do i = 1 to nrReq:
      etime(true).
      if requestMethod eq "GET" then
        httpResponse = httpClient:Get(requestUrl).
      else
        httpResponse = httpClient:Delete(requestUrl).
      this-object:HandleError(httpResponse).
      message substitute("&1 : etime &2 msec - &3 &4"
                        ,string(i, "999")
                        ,etime
                        ,httpResponse:Status
                        ,httpResponse:Reason).
    end.

    totalMsec = interval(now, begin, "milliseconds").

    message substitute("~n  Finished &1 &2 requests in &3 seconds (excl. dry)~n", nrReq, requestMethod, round(totalMsec / 1000, 3))
          //substitute("Average &1 milliseconds~n", round(totalMsec / nrReq, 3))
            substitute("~n  HttpClient     : &1", httpClient:GetClass():TypeName)
            substitute("~n  Request url    : &1", requestUrl)
            substitute("~n  Request method : &1", requestMethod).

  end method.

  /*------------------------------------------------------------------------------
    Purpose: Execute a x number of POST requests
    Notes:
  ------------------------------------------------------------------------------*/
  method public void ExecutePostPutRequests (nrReq as int):

    var int i, totalMsec.
    var datetime-tz begin.

    var HttpResponse       httpResponse.
    var IHttpClient        httpClient = HttpClientFactory:Get(httpClientIdentifier).
    var HttpRequestOptions options    = new HttpRequestOptions():SetContentType("application/json").
    var JsonObject         body       = new JsonObject().

    //if not requestUrl matches "*/todos" then
    //  undo, throw new AppError(substitute("POST url '&1' is not implemented", requestUrl), -1).

    // "id" will be determined by the host
    body:Add("userId", 10).
    body:Add("title", substitute("&1 at : &2", lc(requestMethod), iso-date(now))).
    body:Add("completed", true).

    // dry run
    etime(true).
    if requestMethod eq "POST" then
      httpResponse = httpClient:Post(requestUrl, body, options).
    else
      httpResponse = httpClient:Put(requestUrl, body, options).
    this-object:HandleError(httpResponse).
    message substitute("dry : etime &1 msec~n~n~n", etime).

    if httpResponse:Status ge 400 then
      undo, throw new AppError(substitute("Error: &1 - &2", httpResponse:Status, httpResponse:Reason), -1).

    begin = now.

    do i = 1 to nrReq:
      etime(true).
      if requestMethod eq "POST" then
        httpResponse = httpClient:Post(requestUrl, body, options).
      else
        httpResponse = httpClient:Put(requestUrl, body, options).
      this-object:HandleError(httpResponse).
      message substitute("&1 : etime &2 msec - &3 &4 "
                        ,string(i, "999"), etime
                        ,httpResponse:Status
                        ,httpResponse:Reason)
                       //+ string(cast(httpResponse:Body, JsonObject):GetJsonText())
                         .
    end.

    totalMsec = interval(now, begin, "milliseconds").

    message substitute("~n  Finished &1 &2 requests in &3 seconds (excl. dry)~n", nrReq, requestMethod, round(totalMsec / 1000, 3))
            substitute("~n  HttpClient     : &1", httpClient:GetClass():TypeName)
            substitute("~n  Request url    : &1", requestUrl)
            substitute("~n  Request method : &1", requestMethod).

  end method.

end class.
