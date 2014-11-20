#!/bin/bash

# This is the entrypoint script for the dockerfile. Executed in the
# container at runtime.

# These need to get passed in by the caller.
# ie. docker run -e BUILDER_UID=$( id -u ) BUILDER_GID=$( id -g ) ...
: ${BUILDER_UID?} ${BUILDER_GID?} ${BUILD_PREFIX?}

BUILDER_USER=build-user
BUILDER_GROUP=build-group

# Create a group with the given GID unless it already exists.
grep -q :$BUILDER_GID: /etc/group || groupadd -g $BUILDER_GID $BUILDER_GROUP

# Create a user with the given UID (TODO: what if uid exists?)
useradd -g $BUILDER_GID -u $BUILDER_UID $BUILDER_USER

# Set up some of the usual makefile variables
export AS=$BUILD_PREFIX-as
export AR=$BUILD_PREFIX-ar
export CC=$BUILD_PREFIX-gcc
export CPP=$BUILD_PREFIX-cpp
export CXX=$BUILD_PREFIX-g++
export LD=$BUILD_PREFIX-ld

# Finally, su to the user and run the command
su -c "$*" $BUILDER_USER
