/*------------------------------------------------------------------------
  File        : createPets.p
  Purpose     :
  Syntax      :
  Description :
  Author(s)   : arno
  Created     : Wed Oct 15 09:09:50 CEST 2025
  Notes       :
----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using flusso.http.HttpClientFactory.
using flusso.http.HttpRequestOptions.
using flusso.http.HttpResponse.
using flusso.http.IHttpClient.

// default-http-client, abl-http-client, dotnet-http-client
var char     clientIdentifier = (if session:parameter gt "" then session:parameter else "default-http-client").
var char     postUrl          = "http://petstore:8080/api/pet".
//var char     postUrl       = "http://10.211.55.2:8080/api/pet".
var longchar singlePetBody    = '~{"id":<ID>,"category":~{"id":1,"name":"Dogs"},"name":"Demodog-<ID>","photoUrls":["www.flusso.nl"],"tags":[~{"id":1,"name":"male"}],"status":"demo"}'
           , singlePet.
var int      id = 90000, counter.

var JsonObject         jsonPet, idObj = new JsonObject().
var ObjectModelParser  parser = new ObjectModelParser().
var IHttpClient        client = HttpClientFactory:Get(clientIdentifier).
var HttpRequestOptions args   = new HttpRequestOptions():SetContentType("application/json")
                                                        :SetHeader("Accept", "application/json").
var HttpResponse       response.

etime(true).
do while true:
  singlePet = replace(singlePetBody, "<ID>", string(id)).
  jsonPet   = cast(parser:Parse(singlePet), JsonObject).
  response  = client:Post(postUrl, jsonPet, args).
  message substitute("Created pet with name: Demodog-&1  (status=&2)", id,  response:Status).
  counter += 1.
  if counter ge 750 then
    leave.
  id += 1.
end.

message "".
message substitute("[&3] Created &2 pets in &1 seconds!", string(etime / 1000), counter,
                   client:GetClass():TypeName).
message "".

// save ids
idObj:Add("firstId", 90000).
idObj:Add("lastId", id).
idObj:WriteFile("pet_ids.json", true).
