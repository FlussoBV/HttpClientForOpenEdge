
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
    File        : HttpRequestOptions
    Purpose     : 
    Syntax      : 
    Author(s)   : bronco / Flusso B.V.
    Created     : Thu Jan 23 12:47:01 +01:00 2025
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using flusso.http.HttpRequestOptions.
using OpenEdge.Core.String.
using Progress.Collections.HashMap.

class flusso.http.HttpRequestOptions:

  define package-protected property Accept as char no-undo get. private set.
  define public property ContentType as char no-undo get. set.
  define public property Headers as HashMap<String, String> no-undo get. private set.
  define public property QueryParameters as HashMap<String, String> no-undo get. private set.


  constructor public HttpRequestOptions():
    Headers = new HashMap<String, String>().
    QueryParameters = new HashMap<String, String>().
  end constructor.

  method public HttpRequestOptions SetAccept(mimeType as char):
    Accept = mimeType.
    return this-object.
  end method.

  method public HttpRequestOptions SetContentType(mimeType as char):
    ContentType = mimeType.
    return this-object.
  end method.

  method public HttpRequestOptions AddHeader(headerName as char, headerValue as char):
    this-object:Headers:Add(new String(headerName), new String(headerValue)).
    return this-object.
  end method.

  method public HttpRequestOptions AddQueryParameter(parameterName as char, parameterValue as char):
    this-object:QueryParameters:Add(new String(parameterName), new String(parameterValue)).
    return this-object.
  end method.

end class.  // HttpRequestOptions
