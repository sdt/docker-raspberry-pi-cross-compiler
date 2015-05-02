# Raspberry Pi cross-compilation in a Docker container.

Installs [the Raspberry Pi cross-compilation toolchain](https://github.com/raspberrypi/tools) onto the [ubuntu:trusty Docker image](https://registry.hub.docker.com/_/ubuntu/).

This project is available as [sdt4docker/raspberry-pi-cross-compiler](https://registry.hub.docker.com/u/sdt4docker/raspberry-pi-cross-compiler/) on [Docker Hub](https://hub.docker.com/), and as [sdt/docker-raspberry-pi-cross-compiler](https://github.com/sdt/docker-raspberry-pi-cross-compiler) on [GitHub](https://github.com).

Please raise any issues on the [GitHub issue tracker](https://github.com/sdt/docker-raspberry-pi-cross-compiler/issues) as I don't get notified about Docker Hub comments.

## Features

* all four builds from [raspberrypi/tools](https://github.com/raspberrypi/tools) are available
* commands in the container are run as the calling user, so that any created files have the expected ownership (ie. not root)
* make variables (`CC`, `LD` etc) are set to point to the appropriate tools in the container
* `ARCH`, `CROSS_COMPILE` and `HOST` environment variables are set in the container
* symlinks such as `rpxc-gcc` and `rpxc-objdump` are created in `/usr/local/bin`
* current directory is mounted as the container's workdir, `/build`
* works with boot2docker on OSX

## Installation

This image is not intended to be run manually. Instead, there is a helper script which comes bundled with the image.

To install the helper script, run the image with no arguments, and redirect the output to a file.

eg.
```
docker run sdt4docker/raspberry-pi-cross-compiler > rpxc
chmod +x rpxc
mv rpxc ~/bin/
```

## Usage

`rpxc [command] [args...]`

Execute the given command-line inside the container.

If the command matches one of the rpxc built-in commands (see below), that will be executed locally, otherwise the command is executed inside the container.

---

`rpxc -- [command] [args...]`

To force a command to run inside the container (in case of a name clash with a built-in command), use `--` before the command.

### Built-in commands

`rpxc update-image`

Fetch the latest version of the docker image.

---

`rpxc update-script`

Update the installed rpxc script with the one bundled in the image.

----

`rpxc update`

Update both the docker image, and the rpxc script.

## Configuration

The following command-line options and environment variables are used. In all cases, the command-line option overrides the environment variable.

### RPXC_CONFIG / --config &lt;path-to-config-file&gt;

This file is sourced if it exists.

Default: `~/.rpxc`

### RPXC_IMAGE / --image &lt;docker-image-name&gt;

The docker image to run.

Default: sdt4docker/raspberry-pi-cross-compiler

### RPXC_TARGET / --target &lt;target-name&gt;

Which cross-compiler toolchain to use.

Available toolchains:

* gnusw [arm-bcm2708-linux-gnueabi](https://github.com/raspberrypi/tools/tree/master/arm-bcm2708/arm-bcm2708-linux-gnueabi)
* gnuhw [arm-bcm2708-linuxhardfp-gnueabi](https://github.com/raspberrypi/tools/tree/master/arm-bcm2708/arm-bcm2708hardfp-linux-gnueabi)
* raspbian32 [gcc-linaro-arm-linux-gnueabihf-raspbian](https://github.com/raspberrypi/tools/tree/master/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian)
* raspbian64 [gcc-linaro-arm-linux-gnueabihf-raspbian-x64](https://github.com/raspberrypi/tools/tree/master/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64)

Default: raspbian32

### RPXC_ARGS / --args &lt;docker-run-args&gt;

Extra arguments to pass to the `docker run` command.

## Examples

`rpxc make`

Build the Makefile in the current directory.

---

`rpxc rpxc-gcc -o hello-world hello-world.c`

Standard bintools are available by adding an `rpxc-` prefix.

---

`rpxc make`

Build the kernel from [raspberrypi/linux](https://github.com/raspberrypi/linux).
The CROSS_COMPILE and ARCH flags are automatically set.

---

`rpxc bash -c 'find . -name \*.o | sort > objects.txt'`

Note that commands are executed verbatim. If you require any shell processing for environment variable expansion or redirection, please use `bash -c 'command args...'`.

---

More examples can be found in the [examples directory](examples).
