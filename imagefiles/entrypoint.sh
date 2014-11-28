#!/bin/bash

# This is the entrypoint script for the dockerfile. Executed in the
# container at runtime.

# If we are running docker natively, we want to create a user in the container
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

if [[ -n $CROSS_COMPILE ]]; then

    # CROSS_COMPILE got passed in by the user, so assume we got called by rpxc
    export CROSS_COMPILE

    # Set up some of the usual makefile variables
    export AS=${CROSS_COMPILE}as
    export AR=${CROSS_COMPILE}ar
    export CC=${CROSS_COMPILE}gcc
    export CPP=${CROSS_COMPILE}cpp
    export CXX=${CROSS_COMPILE}g++
    export LD=${CROSS_COMPILE}ld

    # Create rpxc- prefixed symlinks in /usr/local/bin (eg. rpxc-gcc, rpxc-ld)
    for i in ${CROSS_COMPILE}*; do
        ln -s $i /usr/local/bin/rpxc-${i#$CROSS_COMPILE}
    done

    # And finally ... run the command we were asked to run!
    # Note that $BUILDER_USER might not be set
    exec sudo -E -u $BUILDER_USER "$@"
else
    # Presumably the image has been run directly, so help the user # get going.
    cat /rpxc/rpxc
fi
