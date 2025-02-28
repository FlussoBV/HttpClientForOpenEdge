/*------------------------------------------------------------------------
  File        : HttpResponse
  Purpose     :
  Syntax      :
  Author(s)   : bronco / arno
  Created     : Thu Jan 23 12:40:13 +01:00 2025
  Notes       : Copyright 2025 Flusso B.B.
                Developed under MIT License, see LICENSE file
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.String.
using Progress.Collections.HashMap.

class flusso.http.HttpResponse
  serializable:

  define public property Status      as int  no-undo get. package-protected set.
  define public property Reason      as char no-undo get. package-protected set.
  define public property ContentType as char no-undo get. set.

  define public property Headers as HashMap<String, String> no-undo get. package-protected set.
  define public property Body    as Progress.Lang.Object    no-undo get. package-protected set.

  /*------------------------------------------------------------------------------
    Purpose: Constructor
    Notes:
  ------------------------------------------------------------------------------*/
  constructor public HttpResponse():
    Headers = new HashMap<String, String>().
  end constructor.

end class.  // HttpResponse
