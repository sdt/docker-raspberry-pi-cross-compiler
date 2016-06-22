#!/bin/bash -e

source config.sh

cd repo
rpxc sh -c './configure -v -device linux-rasp-pi2-g++ -device-option CROSS_COMPILE=$CROSS_COMPILE -sysroot $SYSROOT -prefix /opt -extprefix /opt -opensource -confirm-license -make libs -nomake tests -no-linuxfb -no-xcb -no-qml-debug -no-cups -no-pulseaudio -no-alsa -no-evdev -qt-libjpeg -qt-libpng'
