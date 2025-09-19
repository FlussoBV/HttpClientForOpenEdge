 
 /*------------------------------------------------------------------------
    File        : ByteArrayHelper
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : rkelters
    Created     : Wed Jul 30 09:14:04 CEST 2014
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

routine-level on error undo, throw.

class flusso.util.ByteArrayHelper: 
  method public static "System.Byte[]" MemptrToByteArray( pmptr as memptr ):
    define variable nPtr   as System.IntPtr   no-undo.
    define variable vInt   as integer         no-undo.
    define variable nBytes as "System.Byte[]".
    
    vInt = get-size(pmPtr).
    nBytes = new "System.Byte[]"(vInt).
    nPtr = new System.IntPtr(get-pointer-value(pmPtr)).
    System.Runtime.InteropServices.Marshal:Copy(nPtr, nBytes, 0, vInt).
    
    return nBytes.
    finally:
/*      nPtr = ?.*/
      delete object nPtr.
      SET-SIZE(pmPtr) = 0.
      nBytes = ?.
    end.
        
  end method.
  
  method public static memptr ByteArrayToMemptr( nBytes as "System.Byte[]" ):
    define variable nPtr as System.IntPtr no-undo.
    define variable mPtr as memptr        no-undo.

    set-size(mPtr) = nBytes:LENGTH.
    nPtr = new System.IntPtr(get-pointer-value(mPtr)).
    System.Runtime.InteropServices.Marshal:Copy(nBytes, 0, nPtr, nBytes:LENGTH).
    return mPtr.
    finally:
/*      nPtr = ?.*/
      delete object nPtr.
      nBytes = ?. 
      SET-SIZE(mPtr) = 0.
    end.
  end method.

	method public static longchar ByteArrayToLongChar( input data as "System.Byte[]" ):
    define variable result       as longchar                  no-undo.
    define variable memStream    as "System.IO.MemoryStream"  no-undo.
    define variable streamReader as "System.IO.StreamReader"  no-undo.

    if valid-object(data)
    then do:
      memStream = new System.IO.MemoryStream(data).
      memStream:Position = 0.
      streamReader = new System.IO.StreamReader(memStream).
      result = streamReader:ReadToEnd () .
      delete object memStream.
      delete object streamReader.
    end.

    return result.

	end method.

end class.