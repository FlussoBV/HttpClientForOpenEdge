block-level on error undo, throw.

using OpenEdge.Core.Session.
using flusso.demo.DemoRunner.
using flusso.factory.Factory.
using flusso.factory.IFactory.

var char       identifier.
var IFactory   factory.
var DemoRunner runner.

session:appl-alert-boxes = true.

identifier = "demo-abl-https-post".
factory    = new Factory("flusso/demo/demo_factory.json").
runner     = cast(factory:GetInstance(identifier), DemoRunner).

runner:Run(1).
 