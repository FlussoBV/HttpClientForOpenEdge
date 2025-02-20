
/**
MIT License

Copyright (c) 2025 Flusso B.V.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
**/

/*------------------------------------------------------------------------
    File        : HttpClientFactory
    Purpose     : 
    Syntax      : 
    Author(s)   : bronco / Flusso B.V.
    Created     : Fri Jan 24 14:13:27 +01:00 2025
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using flusso.http.HttpClientFactory.
using flusso.http.IAppHttpClient.
using Progress.Collections.HashMap.
using OpenEdge.Core.String.

class flusso.http.HttpClientFactory:
  
  var private static HttpClientFactory instance.
  var private HashMap<String, IAppHttpClient> clients.

  constructor static HttpClientFactory():
    instance = new HttpClientFactory().
    instance:clients = new HashMap<String, IAppHttpClient>().
  end constructor.

  // return a new instance of AppHttpClient
  method public static IAppHttpClient Get():
    var IAppHttpClient client.
    client = dynamic-new "flusso.http.AppHttpClient" ().
    return client.
  end method.  // Get

  method public static IAppHttpClient Get(clientName as char):

    var IAppHttpClient client.
    
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
