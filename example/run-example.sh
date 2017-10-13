#!/bin/bash -e

if [[ ! ( $# == 2 && ( $1 == 'jessie' || $1 == 'stretch' ) )  ]]; then
    echo usage: $0 jessie\|stretch example-dir 1>&2
    exit 1
fi

export RPXC_DISTRO=$1

cd $2
./00-get-repo.sh
./01-build-image.sh
./02-configure.sh
./03-make.sh
./04-tar.sh
