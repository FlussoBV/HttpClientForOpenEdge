/*------------------------------------------------------------------------
  File        : ErrorHelper
  Purpose     :
  Syntax      :
  Description :
  Author(s)   : arno
  Created     : Fri Sep 05 19:56:53 CEST 2025
  Notes       : Copyright 2025 Flusso B.V.
                Developed under MIT License, see LICENSE file
----------------------------------------------------------------------*/

block-level on error undo, throw.

using System.Exception.

class flusso.util.ErrorHelper:

  /*------------------------------------------------------------------------------
    Purpose:
    Notes:
  ------------------------------------------------------------------------------*/
  method public static void LogError (err as Progress.Lang.Error):

    var int i.
    var Exception inner.

    //do i = 1 to err:NumMessages:
    //  message substitute("** [&1] &2", i, err:GetMessage(i)).
    //end.
    message substitute("--> Error(s) (&1)", err:NumMessages). 
    message substitute("** &1", err:GetMessage(1)).
    if err:CallStack gt "" then
      message err:CallStack.

    if type-of(err, Exception) then do:
      inner = cast(err, Exception):InnerException.
      do while valid-object(inner):
        message substitute("~n--> Caused by (&1):", inner:NumMessages).
        //do i = 1 to inner:NumMessages:
        //  message substitute("** [&1] &2", i, inner:GetMessage(i)).
        //end.
        message substitute("** &1", inner:GetMessage(1)).
        if inner:CallStack gt "" then
          message inner:CallStack.

        inner = inner:InnerException.
      end. // do while
    end.

  end method.

end class.
