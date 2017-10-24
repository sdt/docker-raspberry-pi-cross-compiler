FROM debian:stretch

# Here is where we hardcode the toolchain decision.
ENV HOST=arm-linux-gnueabihf \
    TOOLCHAIN=gcc-linaro-arm-linux-gnueabihf-raspbian-x64 \
    RPXC_ROOT=/rpxc

ENV ARCH=arm \
    CROSS_COMPILE=$RPXC_ROOT/bin/$HOST- \
    PATH=$RPXC_ROOT/bin:$PATH \
    QEMU_PATH=/usr/bin/qemu-arm-static \
    QEMU_EXECVE=1 \
    SYSROOT=$RPXC_ROOT/sysroot

WORKDIR $SYSROOT
COPY dev.tar.gz /tmp
RUN mkdir -p $SYSROOT/dev/ \
 && ls -alF $SYSROOT/dev \
 && tar -xzvf /tmp/dev.tar.gz \
 && ls -alF $SYSROOT/dev

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

WORKDIR $RPXC_ROOT
RUN curl -L https://github.com/raspberrypi/tools/tarball/master \
  | tar --wildcards --strip-components 3 -xzf - "*/arm-bcm2708/$TOOLCHAIN/"

RUN curl -Ls https://github.com/schachr/docker-raspbian-stretch/raw/master/raspbian.image.tar.xz \
    | tar -xJf - \
 && curl -Ls https://github.com/resin-io-projects/armv7hf-debian-qemu/raw/master/bin/qemu-arm-static \
    > $SYSROOT/$QEMU_PATH \
 && chmod +x $SYSROOT/$QEMU_PATH \
 && mkdir -p $SYSROOT/build \
 && mount --bind /dev $SYSROOT/dev \
 && echo mknod -m 666 $SYSROOT/dev/null    c 1 3 \
 && echo mknod -m 666 $SYSROOT/dev/random  c 1 8 \
 && echo mknod -m 666 $SYSROOT/dev/urandom c 1 9 \
 && echo "deb http://archive.raspbian.org/raspbian stretch firmware" \
    >> $SYSROOT/etc/apt/sources.list \
 && chroot $SYSROOT $QEMU_PATH /bin/sh -c '\
        apt-get update \
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
