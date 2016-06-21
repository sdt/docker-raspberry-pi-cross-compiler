#!/bin/bash

source config.sh
docker build -t $RPXC_IMAGE .
