# Raspberry Pi cross-compilation in a Docker container.

Installs [the Raspberry Pi cross-compilation toolchain](https://github.com/raspberrypi/tools) onto the [ubuntu:trusty Docker image](https://registry.hub.docker.com/_/ubuntu/).

This project is available as [stephenthirlwall/rpi-xc](https://registry.hub.docker.com/u/stephenthirlwall/rpi-xc/) on [Docker Hub](https://hub.docker.com/), and as [sdt/docker-raspberrypi-cross-compiler](https://github.com/sdt/docker-raspberrypi-cross-compiler) on [GitHub](https://github.com).


## Features

* make variables (CC, LD etc) are set to point to the appropriate tools in the container
* ARCH=arm and CROSS_COMPILE environment variables are set in the container
* commands in the container are run as the calling user, so that any created files have the expected ownership (ie. not root)
* symlinks such as rpi-gcc and rpi-objdump are created in /usr/local/bin
* current directory is mounted as the container's workdir, /build
* works with boot2docker on OSX

## Installation

This image is not intended to be run manually. Instead, there is a helper script which comes bundled with the image.

To install the helper script, run the image with no arguments, and redirect the output to a file.

eg.
```
docker run stephenthirlwall/rpi-xc > rpi-xc
chmod +x rpi-xc
mv rpi-xc ~/bin/
```

## Usage

`rpi-xc <command> [args...]`

Runs the given command in a fresh container.

## Configuration

The following environment variables are used:

### RPI_XC_CONFIG

This file is sourced if it exists.

Default: `~/.rpi-xc`

### RPI_XC_IMAGE

The docker image to run.

Default: stephenthirlwall/rpi-xc

### RPI_XC_ARGS

Extra arguments to pass to the `docker run` command.

## Examples

`rpi-xc make`

Build the Makefile in the current directory.

---

`rpi-xc rpi-gcc -o hello-world hello-world.c`

Standard bintools are available by adding an `rpi-` prefix.

---

`rpi-xc make`

Build the kernel from [raspberrypi/linux](https://github.com/raspberrypi/linux).
The CROSS_COMPILE and ARCH flags are automatically set.

---

`rpi-xc bash -c 'find . -name \*.o | sort > objects.txt'`

Note that commands are executed verbatim. If you require any shell processing for environment variable expansion or redirection, please use `bash -c 'command args...'`.
