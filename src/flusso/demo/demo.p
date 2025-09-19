/*----------------------------------------------------------------------
  File        : demo.p
  Purpose     :
  Syntax      :
  Description :
  Author(s)   : arno
  Created     : Tue Apr 08 20:08:28 CEST 2025
  Notes       : Copyright 2025 Flusso B.V.
                Developed under MIT License, see LICENSE file
----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Lang.AppError.
using flusso.demo.DemoRunner.
using flusso.factory.Factory.
using flusso.factory.IFactory.
using flusso.util.ErrorHelper.

var char       identifier = entry(1, session:parameter).
var int        nrRuns.
var IFactory   factory.
var DemoRunner runner.

session:error-stack-trace = true.

if    identifier eq "version"
   or identifier eq "--version" then do:
  message ".NET version:" System.Environment:Version:ToString().
  return.
end.

factory = new Factory("flusso/demo/demo_factory.json").
runner  = cast(factory:GetInstance(identifier), DemoRunner).
nrRuns  = int(entry(2, session:parameter)) no-error.

runner:Run(nrRuns).

catch err as Progress.Lang.Error:
    if err:GetMessage(1) begins "no definition found" then do:
      message "~nAvailable factory identifiers:".
      message "------------------------------".
      cast(factory, Factory):ShowAvailableIdentifiers().
    end.
    else ErrorHelper:LogError(err).
end catch.

finally:
  quit.
end finally.
