#!/bin/bash

export PROPATH=,/usr/dlc/tty/netlib/OpenEdge.Net.apl

rm -f out.log
touch out.log

mbpro -clrnetcore -p flusso/demo/demo.p -param "$1" > out.log

tail -f out.log
