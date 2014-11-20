#!/bin/bash

USER=stephenthirlwall
NAME=rpicc

IMAGE=$USER/$NAME
PREFIX=/rpi/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-

CMD=$1 ; shift

case $CMD in

    build)
        docker build -t $IMAGE .
        ;;

    run)
        docker run --rm -v $PWD:/build \
            -e CC=${PREFIX}gcc \
            $IMAGE "$@"
        ;;

    *)
        echo usage: $0 build
        echo usage: $0 run '[ cmd args ... ]'
        exit 1
        ;;
esac
