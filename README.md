# Raspberry Pi cross-compilation in a Docker container.

Installs [the Raspberry Pi cross-compilation toolchain](https://github.com/raspberrypi/tools) onto the [ubuntu:trusty Docker image](https://registry.hub.docker.com/_/ubuntu/).

Note: this is very much a work in progress

## Build the docker image

`./docker.sh build`

## Run a command in the docker image

`./docker.sh run make`

## Features

* make variables (CC, LD etc) are set to point to the appropriate tools in the container
* commands in the container are run as the calling user, so that any created files have the expected ownership (ie. not root)
