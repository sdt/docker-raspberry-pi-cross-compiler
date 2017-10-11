#!/bin/bash

if [[ $# == 1 && $1 == 'jessie' ]]; then
    BASE_IMAGE=debian:jessie
    DISTRO=jessie
    SYSROOT_URL=https://github.com/sdhibit/docker-rpi-raspbian/raw/master/raspbian.2015.05.05.tar.xz
elif [[ $# == 1 && $1 == 'stretch' ]]; then
    BASE_IMAGE=debian:stretch
    DISTRO=stretch
    SYSROOT_URL=https://github.com/schachr/docker-raspbian-stretch/raw/master/raspbian.image.tar.xz
else
    echo usage: $0 jessie\|stretch 1>&2
    exit 1
fi

: ${RPXC_IMAGE:=sdthirlwall/raspberry-pi-cross-compiler:$1}

docker build \
    --build-arg BASE_IMAGE="$BASE_IMAGE" \
    --build-arg DISTRO="$DISTRO" \
    --build-arg SYSROOT_URL="$SYSROOT_URL" \
    -t "$RPXC_IMAGE" \
    .
