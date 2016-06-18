#!/bin/bash

# This is the entrypoint script for the dockerfile. Executed in the
# container at runtime.

if [[ $# == 0 ]]; then
    # Presumably the image has been run directly, so help the user get started.
    cat /rpxc/rpxc
    exit 0
fi

# If we are running docker natively, we want to create a user in the container
# with the same UID and GID as the user on the host machine, so that any files
# created are owned by that user. Without this they are all owned by root.
# If we are running from boot2docker, this is not necessary, and you end up not
# being able to write to the volume.
# The rpxc script sets the BUILDER_UID and BUILDER_GID vars.
if [[ -n $BUILDER_UID ]] && [[ -n $BUILDER_GID ]]; then

    BUILDER_USER=rpxc-user
    BUILDER_GROUP=rpxc-group
    BUILDER_HOME=/home/$BUILDER_USER

    groupadd -o -g $BUILDER_GID $BUILDER_GROUP 2> /dev/null
    useradd -o -m -d $BUILDER_HOME -g $BUILDER_GID -u $BUILDER_UID $BUILDER_USER 2> /dev/null

    # Run the command as the specified user/group.
    exec HOME=$BUILDER_HOME chpst -u :$BUILDER_UID:$BUILDER_GID "$@"
else
    # Just run the command as root.
    exec "$@"
fi
