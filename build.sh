#!/bin/bash

: ${RPI_XC_IMAGE:=stephenthirlwall/rpi-xc}

docker build -t $RPI_XC_IMAGE .
