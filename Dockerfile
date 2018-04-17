FROM debian:stretch

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils \
 && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure apt-utils \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        automake \
        cmake \
        curl \
        fakeroot \
        g++ \
        git \
        make \
        runit \
        sudo \
        xz-utils

# Here is where we hardcode the toolchain decision.
ENV HOST=arm-linux-gnueabihf \
    TOOLCHAIN=gcc-linaro-arm-linux-gnueabihf-raspbian-x64 \
    RPXC_ROOT=/rpxc

#    TOOLCHAIN=arm-rpi-4.9.3-linux-gnueabihf \
#    TOOLCHAIN=gcc-linaro-arm-linux-gnueabihf-raspbian-x64 \

WORKDIR $RPXC_ROOT
RUN curl -L https://github.com/raspberrypi/tools/tarball/master \
  | tar --wildcards --strip-components 3 -xzf - "*/arm-bcm2708/$TOOLCHAIN/"

ENV ARCH=arm \
    CROSS_COMPILE=$RPXC_ROOT/bin/$HOST- \
    PATH=$RPXC_ROOT/bin:$PATH \
    QEMU_PATH=/usr/bin/qemu-arm-static \
    QEMU_EXECVE=1 \
    SYSROOT=$RPXC_ROOT/sysroot

WORKDIR $SYSROOT
RUN curl -Ls https://downloads.raspberrypi.org/raspbian_lite/root.tar.xz \
| tar -xJf -
ADD https://github.com/resin-io-projects/armv7hf-debian-qemu/raw/master/bin/qemu-arm-static $SYSROOT/$QEMU_PATH

RUN chmod +x $SYSROOT/$QEMU_PATH \
 && mkdir -p $SYSROOT/build

RUN chroot $SYSROOT $QEMU_PATH /bin/sh -c '\
        echo "deb http://archive.raspbian.org/raspbian stretch firmware" \
            >> /etc/apt/sources.list \
        && apt-get update \
        && sudo apt-mark hold \
     raspberrypi-bootloader raspberrypi-kernel raspberrypi-sys-mods raspi-config \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils \
        && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure apt-utils \
        && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y \
                libc6-dev \
                symlinks \
        && symlinks -cors /'

COPY image/ /

WORKDIR /build
ENTRYPOINT [ "/rpxc/entrypoint.sh" ]

RUN install-debian libc6-armhf-cross
