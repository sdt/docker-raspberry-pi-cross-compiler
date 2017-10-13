#!/bin/bash -e

source config.sh
docker build --build-arg RPXC_DISTRO=$RPXC_DISTRO -t $RPXC_IMAGE .
