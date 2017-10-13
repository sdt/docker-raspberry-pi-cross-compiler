ARG RPXC_DISTRO

FROM sdthirlwall/raspberry-pi-cross-compiler:$RPXC_DISTRO

# axel uses gettext in the build context
RUN install-debian --update build-essential python

# axel links against openssl
RUN install-raspbian --update libgles2-mesa-dev zlib1g zlib1g-dev
