#!/bin/bash

USER=stephenthirlwall
NAME=rpicc

IMAGE=$USER/$NAME
BUILD_PREFIX=/rpi/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf

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
