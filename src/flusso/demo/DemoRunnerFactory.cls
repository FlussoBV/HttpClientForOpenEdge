/*------------------------------------------------------------------------
  File        : DemoRunnerFactory
  Purpose     :
  Syntax      :
  Description :
  Author(s)   : arno
  Created     : Tue Apr 08 20:11:38 CEST 2025
  Notes       : Copyright 2025 Flusso B.V.
                Developed under MIT License, see LICENSE file
----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.String.
using Progress.Collections.HashMap.
using flusso.demo.DemoRunnerFactory.
using flusso.factory.Factory.
using flusso.factory.IFactory.
using flusso.demo.DemoRunner.

class flusso.demo.DemoRunnerFactory:

  var private static DemoRunnerFactory instance.
  var private HashMap<String, DemoRunner> runners.
  var private IFactory factory.

  /*------------------------------------------------------------------------------
    Purpose: Static constructor
    Notes:
  ------------------------------------------------------------------------------*/
  constructor static DemoRunnerFactory():
    instance = new DemoRunnerFactory().
    instance:runners = new HashMap<String, DemoRunner>().
  end constructor.

  /*------------------------------------------------------------------------------
    Purpose: Constructor
    Notes:
  ------------------------------------------------------------------------------*/
  constructor private DemoRunnerFactory():
    factory = new Factory("factory.json").
  end constructor.

  /*------------------------------------------------------------------------------
    Purpose: Get instance of DemoRunner
    Notes:
    @param identifier Name
    @return DemoRunner
  ------------------------------------------------------------------------------*/
  method public static DemoRunner Get(identifier as char):

    // design choice for now is to have a single instance of each client
    // so we store the client instances in a HashMap

    var DemoRunner runner = instance:runners:GetValue(new String(identifier)).

    if not valid-object(runner) then do:
      runner = cast(instance:factory:GetInstance(identifier), DemoRunner).
      instance:runners:Add(new String(identifier), runner).
    end.

    return runner.

  end method.  // Get

end class.
