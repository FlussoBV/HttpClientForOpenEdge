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

var char       identifier = entry(1, session:parameter).
var int        nrRuns.
var IFactory   factory    = new Factory("flusso/demo/demo_factory.json").
var DemoRunner runner     = cast(factory:GetInstance(identifier), DemoRunner).

nrRuns = int(entry(2, session:parameter)) no-error.

runner:Run(nrRuns).

catch err as Progress.Lang.Error:
    message "Available factory identifiers:".
    message "------------------------------".
    cast(factory, Factory):ShowAvailableIdentifiers().
end catch.

/***
demo-abl-http-get
demo-abl-https-get
demo-abl-http-get-pdf1mb
demo-abl-http-get-pdf10mb

demo-dotnet-http-get
demo-dotnet-https-get
demo-dotnet-http-get-pdf1mb
demo-dotnet-http-get-pdf10mb
***/
