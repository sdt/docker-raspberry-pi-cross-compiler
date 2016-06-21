#!/bin/bash -e

source config.sh

cd repo
rpxc make "$@"
