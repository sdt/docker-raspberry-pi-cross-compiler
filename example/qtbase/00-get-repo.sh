#!/bin/bash -e

git submodule sync
git submodule update --init --recursive -- ./repo
