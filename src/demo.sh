#!/bin/bash

export PROPATH=,/usr/dlc/tty/netlib/OpenEdge.Net.apl

rm -f out.log
touch out.log

mbpro -clrnetcore -p testGetPerf.p > out.log

tail -f out.log
