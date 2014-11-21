#!/bin/bash

# This is the entrypoint script for the dockerfile. Executed in the
# container at runtime.

# This needs to get passed in by the caller.
: ${CCPREFIX?}
export CCPREFIX

# Set up some of the usual makefile variables
export AS=${CCPREFIX}as
export AR=${CCPREFIX}ar
export CC=${CCPREFIX}gcc
export CPP=${CCPREFIX}cpp
export CXX=${CCPREFIX}g++
export LD=${CCPREFIX}ld

# Create rpi- prefixed symlinks in /usr/local/bin (eg. rpi-gcc, rpi-ld)
for i in ${CCPREFIX}*; do
    ln -s $i /usr/local/bin/rpi-${i#$CCPREFIX}
done

# If we are running docker locally, we want to create a user in the container
# with the same UID and GID as the user on the host machine, so that any files
# created are owned by that user. Without this they are all owned by root.
# If we are running from boot2docker, this is not necessary.
if [[ -n $BUILDER_UID ]] && [[ -n $BUILDER_GID ]]; then

    BUILDER_USER=build-user
    BUILDER_GROUP=build-group

    # Create a group with the given GID unless it already exists.
    grep -q :$BUILDER_GID: /etc/group || groupadd -g $BUILDER_GID $BUILDER_GROUP

    # Create a user with the given UID (TODO: what if uid exists?)
    useradd -g $BUILDER_GID -u $BUILDER_UID $BUILDER_USER

else
    BUILDER_USER=root
fi

# And finally ... run the command we were asked to run!
# Note that $BUILDER_USER might not be set
sudo -E -u $BUILDER_USER "$@"
