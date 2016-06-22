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
# The rpxc script sets the RPXC_UID and RPXC_GID vars.
if [[ -n $RPXC_UID ]] && [[ -n $RPXC_GID ]]; then

    RPXC_USER=rpxc-user
    RPXC_GROUP=rpxc-group
    RPXC_HOME=/home/$RPXC_USER

    groupadd -o -g $RPXC_GID $RPXC_GROUP 2> /dev/null
    useradd -o -m -d $RPXC_HOME -g $RPXC_GID -u $RPXC_UID $RPXC_USER 2> /dev/null

    # Run the command as the specified user/group.
    HOME=$RPXC_HOME exec chpst -u :$RPXC_UID:$RPXC_GID "$@"
else
    # Just run the command as root.
    exec "$@"
fi
