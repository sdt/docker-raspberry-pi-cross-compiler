#!/bin/bash -e

source config.sh
docker build -t $RPXC_IMAGE .
