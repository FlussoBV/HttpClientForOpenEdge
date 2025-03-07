/*------------------------------------------------------------------------
  File        : HttpRequestOptions
  Purpose     : 
  Syntax      : 
  Author(s)   : bronco
  Created     : Thu Jan 23 12:47:01 +01:00 2025
  Notes       : Copyright 2025 Flusso B.B.
                Developed under MIT License, see LICENSE file
----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.String.
using Progress.Collections.HashMap.
using flusso.http.HttpRequestOptions.

class flusso.http.HttpRequestOptions:

  define public property Headers         as HashMap<String, String> no-undo get. private set.
  define public property QueryParameters as HashMap<String, String> no-undo get. private set.

  /*------------------------------------------------------------------------------
    Purpose: Constructor
    Notes:
  ------------------------------------------------------------------------------*/
  constructor public HttpRequestOptions():
    this-object:Headers         = new HashMap<String, String>().
    this-object:QueryParameters = new HashMap<String, String>().

    this-object:SetHeader("Accept", "*/*").
  end constructor.

  /*------------------------------------------------------------------------------
    Purpose: Sets Accept value
    Notes:
    @param mimeType ContentType
    @return HttpRequestOptions
  ------------------------------------------------------------------------------*/
  method public HttpRequestOptions SetAccept(mimeType as char):
    this-object:SetHeader("Accept", mimeType).
    return this-object.
  end method.

  /*------------------------------------------------------------------------------
    Purpose: Sets ContentType value
    Notes:
    @param mimeType ContentType
    @return HttpRequestOptions
  ------------------------------------------------------------------------------*/
  method public HttpRequestOptions SetContentType(mimeType as char):
    this-object:SetHeader("Content-Type", mimeType).
    return this-object.
  end method.

  /*------------------------------------------------------------------------------
    Purpose: Adds a header
    Notes:
    @param headerName  Name
    @param headerValue Value
    @return HttpRequestOptions
  ------------------------------------------------------------------------------*/
  method public HttpRequestOptions SetHeader(headerName as char, headerValue as char):
    this-object:Headers:Set(new String(headerName), new String(headerValue)).
    return this-object.
  end method.

  /*------------------------------------------------------------------------------
    Purpose: Adds query parameters
    Notes:
    @param parameterName  Name
    @param parameterValue Value
    @return HttpRequestOptions
  ------------------------------------------------------------------------------*/
  method public HttpRequestOptions AddQueryParameter(parameterName as char, parameterValue as char):
    this-object:QueryParameters:Add(new String(parameterName), new String(parameterValue)).
    return this-object.
  end method.

end class.  // HttpRequestOptions
