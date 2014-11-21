#!/bin/bash

USER=stephenthirlwall
NAME=rpi-xc

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

CCPREFIX=/rpi/arm-bcm2708/$BIN_DIR/bin/$BIN_PREFIX-

CMD=$1 ; shift

case $CMD in

    build)
        docker build -t $IMAGE .
        ;;

    run)
        if [ -z $DOCKER_HOST ]; then
            SU_ARGS="-e BUILDER_UID=$( id -u ) -e BUILDER_GID=$( id -g )"
        fi
        docker run --rm \
            -v $PWD:/build \
            $SU_ARGS \
            -e CCPREFIX=$CCPREFIX \
            $IMAGE "$@"
        ;;

    *)
        echo usage: $0 build
        echo usage: $0 run '[ cmd args ... ]'
        exit 1
        ;;
esac
