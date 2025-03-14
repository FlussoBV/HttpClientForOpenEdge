block-level on error undo, throw.

using OpenEdge.Core.WidgetHandle.
using Progress.IO.JsonSerializer.
using Progress.IO.MemoryOutputStream.
using Progress.Json.ObjectModel.JsonObject.
using flusso.http.DotNetHttpClient.
using flusso.http.HttpRequestOptions.
using flusso.http.HttpResponse.
using flusso.http.IHttpClient.

var character          postPutOrDel = "delete".
var character          url          = "http://httpbin.org/" + postPutOrDel.
var IHttpClient        httpClient   = new DotNetHttpClient().
//var IHttpClient        httpClient   = new AblHttpClient().
var HttpRequestOptions options      = new HttpRequestOptions().
var HttpResponse       httpResponse.
var JsonObject         objBody.
var WidgetHandle       xmlBody.
var longchar           resp, xmlText.
var handle             xmlHandle.

xmlText = "<html>moi</html>". 

create x-document xmlHandle.
xmlHandle:load("longchar", xmlText, false).
xmlBody = new WidgetHandle(xmlHandle, true).


objBody = new JsonObject().
objBody:Add("first_payload_body_param", "bar").
objBody:Add("second_payload_body_param", true).


  options:SetHeader("Content-Type", "text/plain")
         :SetHeader("CustomHeader", "my custom header").

  // json:
  if postPutOrDel eq "post"
  then httpResponse = httpClient:Post(url, objBody, options).
  if postPutOrDel eq "delete"
  then httpResponse = httpClient:Delete(url, objBody, options).
  else httpResponse = httpClient:Put(url, objBody, options).
  // xml:
  //httpResponse = httpClient:Post(url, xmlBody, options).
  // text:
  //httpResponse = httpClient:Post(url, new String("foo, bar"), options).

  message "Response:" httpResponse:Status skip(1)
          string(cast(httpResponse:Body, JsonObject):GetJsonText())
    view-as alert-box.

  run Serialize(httpResponse, output resp).

  copy-lob from object resp to file "C:\temp\_out.json".

//  message string(resp) view-as alert-box.

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
