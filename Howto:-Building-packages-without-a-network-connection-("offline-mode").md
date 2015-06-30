The default assumption made by rump kernel repositories is that a host will be connected to the Internet during the build phase.  This page documents how to prepare "offline" version of a specific package.  The offline version can then be copied to and used on a host without a network connection.

[[buildrump.sh|Repo:-buildrump.sh]]
-----------------------------------

If you want to prepare your own from an arbitrary buildrump.sh revision, do:

* Run `./tarup.sh`

Note: if you do not start with a clean buildrump.sh pull, you may have to run `tarup.sh` with `-f` parameter.

Other repositories
------------------

* `git pull http://repo.rumpkernel.org/repository`
* `cd repository`
* `git submodule update --init --recursive`
* `find . -name .git | xargs rm -rf`

Then tar and/or copy the _repository_ directory where you want to, and build normally.
