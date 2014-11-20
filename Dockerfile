FROM ubuntu:trusty
MAINTAINER Stephen Thirlwall <sdt@dr.com>

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        cmake curl lib32stdc++6 lib32z1

WORKDIR /rpi

RUN curl -L https://github.com/raspberrypi/tools/tarball/master | \
        tar --strip-components 1 -xzf -

WORKDIR /build
