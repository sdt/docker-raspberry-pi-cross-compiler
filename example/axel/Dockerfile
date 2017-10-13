ARG RPXC_DISTRO

FROM sdthirlwall/raspberry-pi-cross-compiler:$RPXC_DISTRO

# axel uses gettext in the build context
RUN install-debian --update autopoint gettext

# axel links against openssl
RUN install-raspbian --update libssl-dev
