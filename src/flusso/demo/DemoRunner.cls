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
    Purpose: Run
    Notes:
  ------------------------------------------------------------------------------*/
  method public void Run ():

    case requestMethod:
      when "GET" then ExecuteGetRequests().
      otherwise undo, throw new AppError(substitute("request method '&1' not implemented", requestMethod), -1).
    end case.

  end method.

  /*------------------------------------------------------------------------------
    Purpose:
    Notes:
  ------------------------------------------------------------------------------*/
  method public void ExecuteGetRequests ():

    var int i.
    var HttpResponse httpResponse.
    var IHttpClient httpClient = HttpClientFactory:Get(httpClientIdentifier).
    var datetime-tz begin.

    // dry run
    httpClient:Get(requestUrl).

    begin = now.

    do i = 1 to 100:
      etime(true).
      httpResponse = httpClient:Get(requestUrl).
      message substitute("&1 - [&2] etime: &3 msec", string(i, "999"), httpClientIdentifier, etime).
    end.

    message substitute("Finished in &1 seconds", string(interval(now, begin, "milliseconds") / 1000)).

  end method.

end class.
