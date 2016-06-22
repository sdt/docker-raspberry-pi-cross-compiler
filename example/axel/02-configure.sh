#!/bin/bash -e

source config.sh

cd repo
rpxc ./autogen.sh
rpxc sh -c 'CFLAGS=--sysroot=$SYSROOT ./configure --host=$HOST --prefix=/opt'
