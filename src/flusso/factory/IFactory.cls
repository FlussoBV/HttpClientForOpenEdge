
/*------------------------------------------------------------------------
    File        : IFactory
    Purpose     : 
    Syntax      : 
    Author(s)   : bronco / Flusso B.V.
    Created     : Mon Feb 10 09:23:20 +01:00 2025
    Notes       : Copyright (c) 2025 Flusso B.V. (MIT license, see attached LICENSE file)
  ----------------------------------------------------------------------*/

interface flusso.factory.IFactory:

  method public Progress.Lang.Object GetInstance(instanceName as char).
  method public Progress.Lang.Object DeleteInstance(instanceName as char).
  method public logical Has(instanceName as char).
  
end interface.  // IFactory
