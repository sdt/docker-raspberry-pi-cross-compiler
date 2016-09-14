#!/bin/bash -e

if [[ $# != 1 ]]; then
    echo usage: $0 example-dir 1>&2
    exit 1
fi

cd $1
./00-get-repo.sh
./01-build-image.sh
./02-configure.sh
./03-make.sh
./04-tar.sh
