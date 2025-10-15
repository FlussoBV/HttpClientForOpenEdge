#!/bin/bash

export PROPATH=../bin,.,/usr/dlc/tty/netlib/OpenEdge.Net.apl,../config

rm -f out.log
touch out.log

# -preloadCLR fails on Linux
mbpro -clrnetcore -assemblies ../assemblies -q -rr -reusableObjects 500000 -p flusso/demo/createPets.p -param "$1" > out.log

tail -f out.log
