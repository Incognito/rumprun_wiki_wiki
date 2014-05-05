The default assumption made by rump kernel packages is that a host will be connected to the Internet during the build phase.  This page documents how to prepare "offline" version of a specific package.  The offline version can then be copied to and used on a host without a network connection.  Note: these instructions are not guaranteed to remain constant, and generally speaking only apply to the current revisions of each package.  The situation will hopefully improve in the future with stable and consistent procedures.

[[buildrump.sh|Repo:-buildrump.sh]]
-----------------------------------

The easiest way is to download a pre-prepared tarball from [SourceForge](http://sourceforge.net/projects/rumpkernel/).  Downloading the tarball is also the only officially supported way.

If you want to prepare your own from an arbitrary buildrump.sh revision, do:

* Run `./tarup.sh`

Note: if you do not start with a clean buildrump.sh pull, you may have to run `tarup.sh` with `-f` parameter.

[[rumprun|Repo:-rumprun]]
-------------------------

* `rm -rf rumprun` (yes, you must start with a fresh clone)
* `git pull http://repo.rumpkernel.org/rumprun`
* `cd rumprun`
* `./buildnb.sh justcheckout`
* `find . -name .git | xargs rm -rf`

Then tar and/or copy the rumprun directory where you want to, and build normally with buildnb + make.