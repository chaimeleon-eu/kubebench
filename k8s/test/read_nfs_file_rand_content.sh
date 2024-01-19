#!/bin/bash

IN=~/datasets/10gbRand
OUT=/tmp/10gbRand 

time ( sync && pv $IN > $OUT && sync )
time ( sync && pv $IN > /dev/null && sync )
time bash -c "sync && rsync -av --info=progress2 $IN $OUT && sync"