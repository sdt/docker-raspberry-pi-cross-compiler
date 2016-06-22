#!/bin/bash -e

source config.sh

cd repo
rpxc sh -c 'make install && tar -czvf /build/qtbase.tar.gz /opt/'
