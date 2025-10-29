#!/bin/bash

export PROPATH=../bin,.,/usr/dlc/tty/netlib/OpenEdge.Net.apl,../config

rm -f out.log
touch out.log

# -preloadCLR fails on Linux
mbpro -pf demo.pf -param "$1,$2" > out.log

tail -f out.log

