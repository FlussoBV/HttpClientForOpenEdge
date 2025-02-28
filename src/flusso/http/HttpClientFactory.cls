
/*------------------------------------------------------------------------
    File        : HttpClientFactory
    Purpose     : 
    Syntax      : 
    Author(s)   : bronco / Flusso B.V.
    Created     : Fri Jan 24 14:13:27 +01:00 2025
    Notes       : Copyright (c) 2025 Flusso B.V. (MIT license, see attached LICENSE file)
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using flusso.factory.Factory.
using flusso.factory.IFactory.
using flusso.http.HttpClientFactory.
using flusso.http.IHttpClient.
using Progress.Collections.HashMap.
using OpenEdge.Core.String.

class flusso.http.HttpClientFactory:
  
  var private static HttpClientFactory instance.
  var private HashMap<String, IHttpClient> clients.
  var private IFactory factory.

  constructor static HttpClientFactory():
    instance = new HttpClientFactory().
    instance:clients = new HashMap<String, IHttpClient>().
  end constructor.

  constructor public HttpClientFactory():
    factory = new Factory("factory.json").
  end constructor.

  // return a new instance of AppHttpClient
  method public static IHttpClient Get():
    return cast(instance:factory:GetInstance("flusso.http.IHttpClient"), IHttpClient).
  end method.  // Get

  method public static IHttpClient Get(clientName as char):

    // design choice for now is to have a single instance of each client
    // so we store the client instances in a HashMap

    var IHttpClient client.
    
    client = instance:clients:GetValue(new String(clientName)).
    if not valid-object(client) then do:
      client = cast(instance:factory:GetInstance(clientName), IHttpClient).
      instance:clients:Add(new String(clientName), client).
    end.

    return client.

  end method.  // Get
  
  method public static logical Remove(clientName as char):
    return instance:clients:Remove(new String(clientName)).
  end method.

end class.  // HttpClientFactory
