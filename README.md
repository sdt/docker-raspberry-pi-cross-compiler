[![CircleCI](https://circleci.com/gh/sdt/docker-raspberry-pi-cross-compiler.svg?style=svg)](https://circleci.com/gh/sdt/docker-raspberry-pi-cross-compiler)
# Raspberry Pi Cross-Compiler in a Docker Container

An easy-to-use  all-in-one cross compiler for the Raspberry Pi.

This project is available as [sdthirlwall/raspberry-pi-cross-compiler](https://registry.hub.docker.com/u/sdthirlwall/raspberry-pi-cross-compiler/) on [Docker Hub](https://hub.docker.com/), and as [sdt/docker-raspberry-pi-cross-compiler](https://github.com/sdt/docker-raspberry-pi-cross-compiler) on [GitHub](https://github.com).

Please raise any issues on the [GitHub issue tracker](https://github.com/sdt/docker-raspberry-pi-cross-compiler/issues) as I don't get notified about Docker Hub comments.

## Contents

* [Features](#features)
* [Installation](#installation)
* [Usage](#usage)
* [Configuration](#configuration)
* [Custom Images](#custom-images)
* [Examples](#examples)

## Features

* The [gcc-linaro-arm-linux-gnueabihf-raspbian-x64 toolchain](https://github.com/raspberrypi/tools/tree/master/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64) from [raspberrypi/tools](https://github.com/raspberrypi/tools)
* Raspbian sysroot from [sdhibit/docker-rpi-raspbian](https://github.com/sdhibit/docker-rpi-raspbian) :new:
* Easy installation of raspbian packages into the sysroot using the [customised qemu arm emulator](https://resin.io/blog/building-arm-containers-on-any-x86-machine-even-dockerhub/) from [resin-io-projects/armv7hf-debian-qemu](https://github.com/resin-io-projects/armv7hf-debian-qemu) :new:
* Easy-to-use front end wrapper program `rpxc`.

## Installation

This image is not intended to be run manually. Instead, there is a helper script which comes bundled with the image.

To install the helper script, run the image with no arguments, and redirect the output to a file.

eg.
```
docker run sdthirlwall/raspberry-pi-cross-compiler > ~/bin/rpxc
chmod +x ~/bin/rpxc
```

## Usage

`rpxc [command] [args...]`

Execute the given command-line inside the container.

If the command matches one of the rpxc built-in commands (see below), that will be executed locally, otherwise the command is executed inside the container.

`rpxc -- [command] [args...]`

To force a command to run inside the container (in case of a name clash with a built-in command), use `--` before the command.

### Built-in commands

#### install-debian

`rpxc install-debian [--update] package packages...`

Install native packages into the docker image. Changes are committed back to the sdthirlwall/raspberry-pi-cross-compiler image.

#### install-raspbian

`rpxc install-raspbian [--update] package packages...`

Install raspbian packages from the raspbian repositories into the sysroot of thedocker image. Changes are committed back to the sdthirlwall/raspberry-pi-cross-compiler image.

#### update-image

`rpxc update-image`

Pull the latest version of the docker image.

If a new docker image is available, any extra packages installed with `install-debian` or `install-raspbian` _will be lost_.

#### update-script

`rpxc update-script`

Update the installed rpxc script with the one bundled in the image.

#### update

`rpxc update`

Update both the docker image and the rpxc script.

## Configuration

The following command-line options and environment variables are used. In all cases, the command-line option overrides the environment variable.

### RPXC_CONFIG / --config &lt;path-to-config-file&gt;

This file is sourced if it exists.

Default: `~/.rpxc`

### RPXC_IMAGE / --image &lt;docker-image-name&gt;

The docker image to run.

Default: sdthirlwall/raspberry-pi-cross-compiler

### RPXC_ARGS / --args &lt;docker-run-args&gt;

Extra arguments to pass to the `docker run` command.

## Custom Images

Using `rpxc install-debian` and `rpxc install-raspbian` are really only intended for getting a build environment together. Once you've figured out which debian and raspbian packages you need, it's better to create a custom downstream image that has all your tools and development packages built in.

### Create a Dockerfile

```Dockerfile
FROM sdthirlwall/raspberry-pi-cross-compiler

# Install some native build-time tools
RUN install-debian scons

# Install raspbian development libraries
RUN install-raspbian libboost-dev-all
```

### Name your image with an RPXC_IMAGE variable and build the image

```sh
export RPXC_IMAGE=my-custom-rpxc-image
docker build -t $RPXC_IMAGE .
```

### With RPXC_IMAGE set, rpxc will automatically use your new image.

```sh
# These are typical cross-compilation flags to pass to configure.
# Note the use of single quotes in the shell command-line. We want the
# variables to be interpolated in the container, not in the host system.
rpxc sh -c 'CFLAGS=--sysroot=$SYSROOT ./configure --host=$HOST'
rpxc make
```

Another way to achieve this is to create a shell script.

```sh
#!/bin/sh
CFLAGS=--sysroot=$SYSROOT ./configure --host=$HOST
make
```

And call it as `rpxc ./mymake.sh`

## Examples

See the [examples directory](https://github.com/sdt/docker-raspberry-pi-cross-compiler/tree/master/example) for some real examples.
