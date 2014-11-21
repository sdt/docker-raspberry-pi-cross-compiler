# Raspberry Pi cross-compilation in a Docker container.

Installs [the Raspberry Pi cross-compilation toolchain](https://github.com/raspberrypi/tools) onto the [ubuntu:trusty Docker image](https://registry.hub.docker.com/_/ubuntu/).

This project is available as [stephenthirlwall/rpi-xc](https://registry.hub.docker.com/u/stephenthirlwall/rpi-xc/) on [Docker Hub](https://hub.docker.com/), and as [sdt/docker-raspberrypi-cross-compiler](https://github.com/sdt/docker-raspberrypi-cross-compiler) on [GitHub](https://github.com).


## Features

* make variables (CC, LD etc) are set to point to the appropriate tools in the container
* ARCH=arm and CROSS_COMPILE environment variables are set in the container
* commands in the container are run as the calling user, so that any created files have the expected ownership (ie. not root)
* symlinks such as rpi-gcc and rpi-objdump are created in /usr/local/bin
* current directory is mounted as the container's workdir, /build

## Usage

`rpi-xc <command> [args...]`

Runs the given command in a fresh container.

## Examples

`rpi-xc make`

Build the Makefile in the current directory.


`rpi-xc rpi-gcc -o hello-world hello-world.c`

Standard bintools are available by adding an `rpi-` prefix.


`rpi-xc make`

Build the kernel from [raspberrypi/linux](https://github.com/raspberrypi/linux).
The CROSS_COMPILE and ARCH flags are automatically set.


`rpi-xc bash -c 'find . -name \*.o | sort > objects.txt'

Note that commands are executed verbatim. If you require any shell processing for environment variable expansion or redirection, please use bash -c `'command args...'`.
