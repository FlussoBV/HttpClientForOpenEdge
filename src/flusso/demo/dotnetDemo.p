/*------------------------------------------------------------------------
  File        : dotnetDemo.p
  Purpose     : 
  Syntax      :
  Description : 
  Author(s)   : arno
  Created     : Tue Apr 15 16:09:42 CEST 2025
  Notes       :
----------------------------------------------------------------------*/

block-level on error undo, throw.

using System.IO.StreamReader.
using System.Net.HttpWebRequest.
using System.Net.HttpWebResponse.
using System.Net.WebResponse.

var longchar result.

var HttpWebRequest httpRequest.
var HttpWebResponse httpResponse.
var StreamReader bodyReader.

// prepare request
httpRequest = HttpWebRequest:CreateHttp("http://jsonplaceholder.typicode.com/todos/1").
httpRequest:Method = "GET".
httpRequest:Headers:Add("Accept", "application/json").

// execute request
httpResponse = cast(httpRequest:GetResponse(), HttpWebResponse).

// get response body
bodyReader = new StreamReader(httpResponse:GetResponseStream()).
result = bodyReader:ReadToEnd().

message httpResponse:StatusCode:value__ skip string(result) view-as alert-box title "DotNet".
