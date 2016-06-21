#!/bin/bash

git submodule sync
git submodule update --init --recursive -- ./repo
