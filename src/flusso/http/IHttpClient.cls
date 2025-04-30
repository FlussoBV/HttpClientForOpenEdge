
/*------------------------------------------------------------------------
    File        : IAppHttpClient
    Purpose     : 
    Syntax      : 
    Author(s)   : bronco / Flusso B.V.
    Created     : Fri Jan 24 11:36:11 +01:00 2025
    Notes       : Copyright (c) 2025 Flusso B.V. (MIT license, see attached LICENSE file)
  ----------------------------------------------------------------------*/

using flusso.http.HttpRequestOptions.
using flusso.http.HttpResponse. 

interface flusso.http.IHttpClient:

  method public HttpResponse Get(url as char).
  method public HttpResponse Get(url as char, options as HttpRequestOptions).

  method public HttpResponse Patch(url as char, data as Progress.Lang.Object).
  method public HttpResponse Patch(url as char, data as Progress.Lang.Object, options as HttpRequestOptions).

  method public HttpResponse Post(url as char, data as Progress.Lang.Object).
  method public HttpResponse Post(url as char, data as Progress.Lang.Object, options as HttpRequestOptions).

  method public HttpResponse Put(url as char, data as Progress.Lang.Object).
  method public HttpResponse Put(url as char, data as Progress.Lang.Object, options as HttpRequestOptions).

  method public HttpResponse Delete(url as char).
  method public HttpResponse Delete(url as char, options as HttpRequestOptions).

end interface.  // IHttpClient
