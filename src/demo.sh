#!/bin/bash

export PROPATH=,/usr/dlc/tty/netlib/OpenEdge.Net.apl

rm -f out.log
touch out.log

# don't use -preloadCLR
mbpro -clrnetcore -p flusso/demo/demo.p -param "$1,$2" > out.log
tail -f out.log
