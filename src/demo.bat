@echo off
setlocal

set PROPATH=.,%DLC%\tty\netlib\OpenEdge.Net.apl

call mbpro -clrnetcore -p flusso\demo\demo.p -basekey "INI" -ininame "win.ini" -param "%1,%2"
