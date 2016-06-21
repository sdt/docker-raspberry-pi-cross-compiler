#!/bin/bash -e

source config.sh

cd repo
rpxc sh -c './configure -v -device linux-rasp-pi2-g++ -device-option CROSS_COMPILE=$CROSS_COMPILE -opensource -confirm-license -make libs -nomake tests -sysroot $SYSROOT -no-linuxfb -no-xcb -no-qml-debug -no-cups -no-pulseaudio -no-alsa -no-evdev -qt-libjpeg -qt-libpng'
