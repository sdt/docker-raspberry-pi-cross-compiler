#!/bin/bash

: ${RPXC_IMAGE:=sdthirlwall/raspberry-pi-cross-compiler:stretch}

docker build -t $RPXC_IMAGE .
