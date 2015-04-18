#!/bin/bash

: ${RPXC_IMAGE:=rpxc-with-git}

docker build -t $RPXC_IMAGE .
