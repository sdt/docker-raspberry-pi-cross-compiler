#!/bin/bash

: ${RPXC_IMAGE:=sdthirlwall/raspberry-pi-cross-compiler:legacy-trusty}

docker build -t $RPXC_IMAGE .
