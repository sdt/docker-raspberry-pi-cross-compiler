#!/bin/bash -e

source config.sh

cd repo
rpxc sh -c 'sudo make install && fakeroot tar -czvf /build/axel.tar.gz /opt/'
