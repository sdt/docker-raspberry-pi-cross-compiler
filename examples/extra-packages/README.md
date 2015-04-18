# Installing extra debian packages into rpxc

This example shows how to install extra packages into rpxc by creating a
downstream image that uses rpxc as a base.

## Step 1 - create a downstream image.

Use sdt4docker/raspberry-pi-cross-compiler as a base, and make any changes you
like. Avoid changing the ENTRYPOINT directive unless you know what you're doing - the rpxc script relies on this.

The example [Dockerfile](Dockerfile) and [build.sh](build.sh) in this directory create an image called rpxc-with-git which installs git.

## Step 2 - tell rpxc to use your image.

Tell rpxc to use your image, and rpxc will continue working as before.
There's multiple ways to do this:

1. Using the --image command-line parameter:
  * `rpxc --image rpxc-with-git git`

2. Using the RPXC_IMAGE environment variable
  * `RPXC_IMAGE=rpxc-with-git git`

3. Add the RPXC_IMAGE environment variable to your ~/.rpxc file (*beware*, this will have a global effect)
  * `export RPXC_IMAGE=rpxc-with-git`

4. [direnv](http://direnv.net/) users can add the RPXC_IMAGE variable to a local .envrc
  * `export RPXC_IMAGE=rpxc-with-git`

