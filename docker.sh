#!/bin/bash

USER=stephenthirlwall
NAME=rpicc

IMAGE=$USER/$NAME

# Raspbian 32-bit
BIN_PREFIX=arm-linux-gnueabihf
BIN_DIR=gcc-linaro-$BIN_PREFIX-raspbian

## Raspbian 64-bit
#BIN_PREFIX=arm-linux-gnueabihf
#BIN_DIR=gcc-linaro-$BIN_PREFIX-raspbian-x64
#
## Software-float GNU (not sure what this is really)
#BIN_PREFIX=arm-bcm2708-linux-gnueabi
#BIN_DIR=$BIN_PREFIX
#
## Hardware-float GNU (not sure what this is really)
#BIN_PREFIX=arm-bcm2708hardfp-linux-gnueabi
#BIN_DIR=$BIN_PREFIX

BUILD_PREFIX=/rpi/arm-bcm2708/$BIN_DIR/bin/$BIN_PREFIX

CMD=$1 ; shift

case $CMD in

    build)
        docker build -t $IMAGE .
        ;;

    run)
        docker run --rm -v $PWD:/build \
            -e BUILDER_UID=$( id -u ) \
            -e BUILDER_GID=$( id -g ) \
            -e BUILD_PREFIX=$BUILD_PREFIX \
            $IMAGE "$@"
        ;;

    *)
        echo usage: $0 build
        echo usage: $0 run '[ cmd args ... ]'
        exit 1
        ;;
esac
