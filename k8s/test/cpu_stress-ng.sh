#!/bin/bash
export UDOCKER_REGISTRY=https://harbor.chaimeleon-eu.i3m.upv.es
export VER=1.0.7
udocker run -e COMMAND='stress-ng --matrix 0 -a 2 -t 1h --times' chaimeleon-services/kubebench:$VER