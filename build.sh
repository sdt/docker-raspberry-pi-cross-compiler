#!/bin/bash

: ${RPXC_IMAGE:=sdt4docker/raspberry-pi-cross-compiler}

docker build -t $RPXC_IMAGE .
