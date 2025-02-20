
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
    File        : IAppHttpClient
    Purpose     : 
    Syntax      : 
    Author(s)   : bronco / Flusso B.V.
    Created     : Fri Jan 24 11:36:11 +01:00 2025
    Notes       : 
  ----------------------------------------------------------------------*/

using flusso.http.HttpRequestOptions.
using flusso.http.HttpResponse. 

interface flusso.http.IHttpClient:

  method public HttpResponse Get(url as char).
  method public HttpResponse Get(url as char, options as HttpRequestOptions).

  method public HttpResponse Post(url as char, data as Progress.Lang.Object).
  method public HttpResponse Post(url as char, data as Progress.Lang.Object, options as HttpRequestOptions).

  method public HttpResponse Put(url as char, data as Progress.Lang.Object).
  method public HttpResponse Put(url as char, data as Progress.Lang.Object, options as HttpRequestOptions).

  method public HttpResponse Delete(url as char, data as Progress.Lang.Object).
  method public HttpResponse Delete(url as char, data as Progress.Lang.Object, options as HttpRequestOptions).

end interface.  // IHttpClient
