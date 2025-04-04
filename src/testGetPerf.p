block-level on error undo, throw.

using Progress.IO.JsonSerializer.
using Progress.IO.MemoryOutputStream.
using Progress.Json.ObjectModel.JsonObject.
using flusso.http.AblHttpClient.
using flusso.http.DotNetHttpClient.
using flusso.http.HttpResponse.
using flusso.http.IHttpClient.
using flusso.http.HttpRequestOptions.

//var character        url = "http://echo.free.beeceptor.com/".
var char               url = "http://jsonplaceholder.typicode.com/posts".
var IHttpClient        httpClient   = new DotNetHttpClient().
var HttpRequestOptions options      = new HttpRequestOptions().
var HttpResponse       httpResponse.
var JsonObject         obj.
var longchar           resp.
var int                i.
var datetime-tz        begin.

  options:SetHeader("Content-Type", "text/plain")
         :SetHeader("CustomHeader", "my custom header").

  options:AddQueryParameter("first_query_param", "boo&bar").
  options:AddQueryParameter("second_query_param", "foo").

  // dry run
  httpClient:Get(url, options).

  begin = now.

  do i = 1 to 100:
    etime(true).
    httpResponse = httpClient:Get(url, options).
    message substitute("&1 - DotNetHttpClient etime: &2", string(i, "999"), etime) view-as alert-box.
  end.

  message substitute("Finished in &1 seconds", string(interval(now, begin, "milliseconds") / 1000)).
