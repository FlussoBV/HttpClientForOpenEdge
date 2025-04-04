block-level on error undo, throw.

using Progress.IO.JsonSerializer.
using Progress.IO.MemoryOutputStream.
using Progress.Json.ObjectModel.JsonObject.
using flusso.http.DotNetHttpClient.
using flusso.http.HttpResponse.
using flusso.http.IHttpClient.
using flusso.http.HttpRequestOptions.

var character          url          = "http://httpbin.org/get".
var IHttpClient        httpClient   = new DotNetHttpClient().
var HttpRequestOptions options      = new HttpRequestOptions().
var HttpResponse       httpResponse.
var JsonObject         obj.
var longchar           resp.

  options:SetHeader("Content-Type", "text/plain")
         :SetHeader("CustomHeader", "my custom header").

  options:AddQueryParameter("first_query_param", "boo&bar").
  options:AddQueryParameter("second_query_param", "foo").

  httpResponse = httpClient:Get(url, options).

  message "Response:" skip
          string(cast(httpResponse:Body, JsonObject):GetJsonText())
    view-as alert-box.


/*  run Serialize(httpResponse, output resp).             */
/*                                                        */
/*  copy-lob from object resp to file "C:\temp\_out.json".*/
/*                                                        */
/*  message string(resp) view-as alert-box.               */

procedure Serialize:
  define input  parameter obj  as Progress.Lang.Object no-undo.
  define output parameter json as longchar             no-undo.

  var MemoryOutputStream outputStream   = new MemoryOutputStream().
  var JsonSerializer     jsonSerializer = new JsonSerializer(true).

  fix-codepage(json) = "utf-8".

  jsonSerializer:Serialize(obj, outputStream).
  outputStream:Close().

  // it seems copy-lob can copy a MEMPTR into a LONGCHAR
  // with this there are no limitations of 32k and special chars
  copy-lob from outputStream:Data to object json.

end procedure.
