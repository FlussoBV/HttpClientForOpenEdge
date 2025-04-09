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

    var int i, totalMsec.
    var HttpResponse httpResponse.
    var IHttpClient httpClient = HttpClientFactory:Get(httpClientIdentifier).
    var datetime-tz begin.

    // dry run
    httpClient:Get(requestUrl).

    begin = now.

    do i = 1 to 100:
      etime(true).
      httpResponse = httpClient:Get(requestUrl).
      message substitute("&1 : etime &2 msec", string(i, "999"), etime).
    end.

    totalMsec = interval(now, begin, "milliseconds").

    message substitute("~n  Finished in &1 seconds~n", round(totalMsec / 1000, 3))
          //substitute("Average &1 milliseconds~n", round(totalMsec / 100, 3))
            substitute("~n  HttpClient     : &1", httpClient:GetClass():TypeName)
            substitute("~n  Request url    : &1", requestUrl)
            substitute("~n  Request method : &1", requestMethod).

  end method.

end class.
