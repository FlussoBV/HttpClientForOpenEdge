@echo off
setlocal

set PROPATH=.,%DLC%\tty\netlib\OpenEdge.Net.apl

call mbpro -pf demo.pf -basekey "INI" -ininame "win.ini" -param "%1,%2"
