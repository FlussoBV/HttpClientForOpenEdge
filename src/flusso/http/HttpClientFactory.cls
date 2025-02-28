
/*------------------------------------------------------------------------
    File        : HttpClientFactory
    Purpose     : 
    Syntax      : 
    Author(s)   : bronco / Flusso B.V.
    Created     : Fri Jan 24 14:13:27 +01:00 2025
    Notes       : Copyright (c) 2025 Flusso B.V. (MIT license, see attached LICENSE file)
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using flusso.http.HttpClientFactory.
using flusso.http.IHttpClient.
using Progress.Collections.HashMap.
using OpenEdge.Core.String.

class flusso.http.HttpClientFactory:
  
  var private static HttpClientFactory instance.
  var private HashMap<String, IHttpClient> clients.

  constructor static HttpClientFactory():
    instance = new HttpClientFactory().
    instance:clients = new HashMap<String, IHttpClient>().
  end constructor.

  // return a new instance of AppHttpClient
  method public static IHttpClient Get():
    var IHttpClient client.
    client = dynamic-new "flusso.http.AppHttpClient" ().
    return client.
  end method.  // Get

  method public static IHttpClient Get(clientName as char):

    var IHttpClient client.
    
    client = instance:clients:GetValue(new String(clientName)).
    if not valid-object(client) then do:
      client = dynamic-new "flusso.http.AppHttpClient" ().
      instance:clients:Add(new String(clientName), client).
    end.

    return client.

  end method.  // Get
  
  method public static logical Remove(clientName as char):
    return instance:clients:Remove(new String(clientName)).
  end method.

end class.  // HttpClientFactory
