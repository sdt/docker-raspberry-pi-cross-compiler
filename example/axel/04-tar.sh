#!/bin/bash -e

source config.sh

cd repo
rpxc sh -c 'make install && tar -czvf /build/axel.tar.gz /opt/'
