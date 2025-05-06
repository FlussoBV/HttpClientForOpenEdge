 
 /*------------------------------------------------------------------------
    File        : bytearrayhelper
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : rkelters
    Created     : Wed Jul 30 09:14:04 CEST 2014
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS util.bytearrayhelper: 
  METHOD PUBLIC STATIC "System.Byte[]" MemptrToByteArray( pmptr AS MEMPTR ):
    DEFINE VARIABLE nPtr   AS System.IntPtr   NO-UNDO.
    DEFINE VARIABLE vInt   AS INTEGER         NO-UNDO.
    DEFINE VARIABLE nBytes AS "System.Byte[]".
    
    vInt = GET-SIZE(pmPtr).
    nBytes = NEW "System.Byte[]"(vInt).
    nPtr = NEW System.IntPtr(GET-POINTER-VALUE(pmPtr)).
    System.Runtime.InteropServices.Marshal:Copy(nPtr, nBytes, 0, vInt).
    
    RETURN nBytes.
    FINALLY:
/*      nPtr = ?.*/
      DELETE OBJECT nPtr.
      SET-SIZE(pmPtr) = 0.
      nBytes = ?.
    END.
        
  END METHOD.
  
  METHOD PUBLIC STATIC MEMPTR ByteArrayToMemptr( nBytes AS "System.Byte[]" ):
    DEFINE VARIABLE nPtr AS System.IntPtr NO-UNDO.
    DEFINE VARIABLE mPtr AS MEMPTR        NO-UNDO.

    set-size(mPtr) = nBytes:LENGTH.
    nPtr = NEW System.IntPtr(GET-POINTER-VALUE(mPtr)).
    System.Runtime.InteropServices.Marshal:Copy(nBytes, 0, nPtr, nBytes:LENGTH).
    RETURN mPtr.
    FINALLY:
/*      nPtr = ?.*/
      DELETE OBJECT nPtr.
      nBytes = ?. 
      SET-SIZE(mPtr) = 0.
    END.
  END METHOD.

	METHOD PUBLIC STATIC LONGCHAR ByteArrayToLongChar( INPUT data AS "System.Byte[]" ):
    DEFINE VARIABLE result       AS LONGCHAR                  NO-UNDO.
    DEFINE VARIABLE memStream    AS "System.IO.MemoryStream"  NO-UNDO.
    DEFINE VARIABLE streamReader AS "System.IO.StreamReader"  NO-UNDO.

    IF VALID-OBJECT(data)
    THEN DO:
      memStream = NEW System.IO.MemoryStream(data).
      memStream:Position = 0.
      streamReader = NEW System.IO.StreamReader(memStream).
      result = streamReader:ReadToEnd () .
      DELETE OBJECT memStream.
      DELETE OBJECT streamReader.
    END.

    RETURN result.

	END METHOD.

END CLASS.