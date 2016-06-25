# rpxc examples

This directory contains examples using rpxc to build real software packages.

Each one contains a git submodule link to the github repo, as well as the
following files:

* `config.sh` has environment variables and is sourced by the other scripts
* `00-get-repo.sh` to pull down the submodule to `repo/`
* `01-build-image.sh` to build a downstream rpxc image from `Dockerfile`
* `02-configure.sh` runs the one-off configure scripts for the source package
* `03-make.sh` builds the package
* `04-tar.sh` installs the package and tars up the install files

The interesting parts are usually in `02-configure.sh`, where we coax the
software package into cross-compiling in the rpxc environment.
