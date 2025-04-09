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
using flusso.demo.DemoRunnerFactory.

var char identifier = session:parameter.
var DemoRunner runner.

if identifier eq "" then
  undo, throw new AppError("no demo factory identifier supplied", -1).

runner = DemoRunnerFactory:Get(identifier).
runner:Run().
