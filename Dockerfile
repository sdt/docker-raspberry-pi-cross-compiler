FROM debian:jessie

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
        pkg-config \
        xz-utils

# Here is where we hardcode the toolchain decision.
ENV HOST=arm-linux-gnueabihf \
    TOOLCHAIN=arm-rpi-4.9.3-linux-gnueabihf \
    RPXC_ROOT=/rpxc

#    TOOLCHAIN=arm-rpi-4.9.3-linux-gnueabihf \
#    TOOLCHAIN=gcc-linaro-arm-linux-gnueabihf-raspbian-x64 \

WORKDIR $RPXC_ROOT
RUN curl -L https://github.com/raspberrypi/tools/tarball/master \
  | tar --wildcards --strip-components 3 -xzf - "*/arm-bcm2708/$TOOLCHAIN/" "*/${HOST}-pkg-config"

ENV ARCH=arm \
    CROSS_COMPILE=$RPXC_ROOT/bin/$HOST- \
    PATH=$RPXC_ROOT/bin:$PATH \
    QEMU_PATH=/usr/bin/qemu-arm-static \
    QEMU_EXECVE=1 \
    SYSROOT=$RPXC_ROOT/sysroot

WORKDIR $SYSROOT
RUN curl -Ls https://github.com/sdhibit/docker-rpi-raspbian/raw/master/raspbian.2015.05.05.tar.xz \
    | tar -xJf - \
 && curl -Ls https://github.com/resin-io-projects/armv7hf-debian-qemu/raw/master/bin/qemu-arm-static \
    > $SYSROOT/$QEMU_PATH \
 && chmod +x $SYSROOT/$QEMU_PATH \
 && mkdir -p $SYSROOT/build \
 && chroot $SYSROOT $QEMU_PATH /bin/sh -c '\
        echo "deb http://archive.raspbian.org/raspbian jessie firmware" \
            >> /etc/apt/sources.list \
        && apt-get update \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils \
        && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure apt-utils \
        && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y \
                libc6-dev \
                symlinks \
        && symlinks -cors /'

COPY image/ /

RUN tar -C ${RPXC_ROOT}/${HOST}/sysroot -c . | tar -C ${SYSROOT} -x ./usr ./lib ./sbin \
	&& mv ${RPXC_ROOT}/${HOST}/sysroot ${RPXC_ROOT}/${HOST}/sysroot-toolchain \
	&& rm ${SYSROOT}/lib/libstdc++.so.6.0.20-gdb.py \
	&& ln -s ${SYSROOT} ${RPXC_ROOT}/${HOST}/sysroot \
	&& ln -s `which pkg-config` ${RPXC_ROOT}/bin/${HOST}-pkg-config-real

WORKDIR /build
ENTRYPOINT [ "/rpxc/entrypoint.sh" ]
