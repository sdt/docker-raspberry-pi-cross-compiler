#!/bin/bash

: ${RPXC_IMAGE:=sdthirlwall/raspberry-pi-cross-compiler}

docker build -t $RPXC_IMAGE .
