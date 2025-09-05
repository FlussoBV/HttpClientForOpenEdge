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
   var private IHttpClient  httpClient.

  /*------------------------------------------------------------------------------
    Purpose: Configure
    Notes:
  ------------------------------------------------------------------------------*/
  method public void Configure (config as JsonObject):

    httpClientIdentifier = config:GetCharacter("httpClientName").
    requestMethod        = config:GetCharacter("method").
    requestUrl           = config:GetCharacter("url").

    httpClient = HttpClientFactory:Get(httpClientIdentifier).

  end method.

  /*------------------------------------------------------------------------------
    Purpose: When the response has a statuscode >= 400, throw as error
    Notes:
  ------------------------------------------------------------------------------*/
  method private void HandleError (httpResponse as HttpResponse):

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
      when "GET" or when "DELETE"
      then ExecuteRequests(nrRuns).
      when "POST" or when "PUT" or when "PATCH"
      then ExecuteRequestsWithBody(nrRuns).
      otherwise undo, throw new AppError(substitute("request method '&1' not implemented", requestMethod), -1).
    end case.

    finally:
      message.
    end finally.

  end method.

  /*------------------------------------------------------------------------------
    Purpose: Execute a x number of GET/DELETE requests (no body)
    Notes:
  ------------------------------------------------------------------------------*/
  method private void ExecuteRequests (nrReq as int):

    ExecuteRequests( httpClient
                   , requestUrl
                   , requestMethod
                   , nrReq
                   , ? ).

  end method.

  /*------------------------------------------------------------------------------
    Purpose: Execute a x number of POST/PUT/PATCH requests
    Notes:
  ------------------------------------------------------------------------------*/
  method private void ExecuteRequestsWithBody (nrReq as int):

    var JsonObject         body       = new JsonObject().

    body:Add("id", 10).
    body:Add("userId", 10).
    body:Add("title", substitute("&1 at : &2", lc(requestMethod), iso-date(now))).
    body:Add("completed", true).

    ExecuteRequests( httpClient
                   , requestUrl
                   , requestMethod
                   , nrReq
                   , body ).


  end method.

  /*------------------------------------------------------------------------------
    Purpose: Execute a x number of POST/PUT/PATCH requests
    Notes:
  ------------------------------------------------------------------------------*/
  method private void ExecuteRequests ( httpClient as IHttpClient
                                      , requestUrl as char
                                      , requestMethod as char
                                      , nrReq as int
                                      , body as JsonObject):

    var int i, totalMsec, dryRunMsec, averageMsec.
    var datetime-tz begin.

    var HttpResponse       httpResponse.
    var HttpRequestOptions options    = new HttpRequestOptions():SetContentType("application/json").

    // dry run
    etime(true).
    case requestMethod:
      when "POST"   then  httpResponse = httpClient:Post(requestUrl, body, options).
      when "PUT"    then  httpResponse = httpClient:Put(requestUrl, body, options).
      when "PATCH"  then  httpResponse = httpClient:Patch(requestUrl, body, options).
      when "GET"    then  httpResponse = httpClient:Get(requestUrl, options).
      when "DELETE" then  httpResponse = httpClient:Delete(requestUrl, options).
    end case.
    this-object:HandleError(httpResponse).
    dryRunMsec = etime.
    message substitute("dry : etime &1 msec~n~n~n", dryRunMsec).

    if httpResponse:Status ge 400 then
      undo, throw new AppError(substitute("Error: &1 - &2", httpResponse:Status, httpResponse:Reason), -1).

    begin = now.

    do i = 1 to nrReq:
      etime(true).
      case requestMethod:
        when "POST"   then  httpResponse = httpClient:Post(requestUrl, body, options).
        when "PUT"    then  httpResponse = httpClient:Put(requestUrl, body, options).
        when "PATCH"  then  httpResponse = httpClient:Patch(requestUrl, body, options).
        when "GET"    then  httpResponse = httpClient:Get(requestUrl, options).
        when "DELETE" then  httpResponse = httpClient:Delete(requestUrl, options).
      end case.
      this-object:HandleError(httpResponse).
      message substitute("&1 : etime &2 msec - &3 &4 "
                        ,string(i, "999"), etime
                        ,httpResponse:Status
                        ,httpResponse:Reason)
                         .
    end.

    totalMsec = interval(now, begin, "milliseconds").
    averageMsec = round(totalMsec / nrReq, 3).

    message substitute("~n  Finished &1 &2 requests in &3 seconds (excl. dry)~n", nrReq, requestMethod, round(totalMsec / 1000, 3))
            substitute("~n  Dry run        : &1 milliseconds", string(dryRunMsec, "zzz9"))
            substitute("~n  Average        : &1 milliseconds", string(averageMsec, "zzz9"))
            substitute("~n  Initialize     : &1 milliseconds~n", string(dryRunMsec - averageMsec, "zzz9"))
            substitute("~n  HttpClient     : &1", httpClient:GetClass():TypeName)
            substitute("~n  Request url    : &1", requestUrl)
            substitute("~n  Request method : &1", requestMethod).

  end method.

end class.
