Travis CI (Linux/x86_64):

* [static and dynamic builds of buildrump.sh/POSIX, clang + gcc](https://travis-ci.org/rumpkernel/buildrump.sh) ![Build Status](https://travis-ci.org/rumpkernel/buildrump.sh.png?branch=master)
* [rump kernels on the Xen hypervisor](https://travis-ci.org/rumpkernel/rumpuser-xen) ![Build Status](https://travis-ci.org/rumpkernel/rumpuser-xen.png?branch=master)
* [rumprun](https://travis-ci.org/rumpkernel/rumprun) ![Build Status](https://travis-ci.org/rumpkernel/rumprun.png?branch=master)
* [DPDK TCP/IP stack driver](https://travis-ci.org/rumpkernel/dpdk-rumptcpip) ![Build Status](https://travis-ci.org/rumpkernel/dpdk-rumptcpip.png?branch=master)
* [netmap TCP/IP stack driver](https://travis-ci.org/rumpkernel/netmap-rumptcpip) ![Build Status](https://travis-ci.org/rumpkernel/netmap-rumptcpip.png?branch=master)

Live Travis reports are sent to __#rumpkernel-builds__ on irc.freenode.net.

Buildbot builds of all buildrump.sh branches, multiple operating systems and machine architectures.
* http://build.myriabit.eu:8011/waterfall

Buildbot builds of buildrump.sh against NetBSD HEAD, multiple operating systems and machine architectures.  Note since these builds are not against a "known good" timestamp of NetBSD sources, there may be transient failures due to problems in the NetBSD tree:
* http://build.myriabit.eu:8012/waterfall

There are buildbot builds of ljsyscall, which includes tests against rump kernels on various architectures
* http://build.myriabit.eu:8010/waterfall

There are buildbot builds of rumprun on various environments
* http://build.myriabit.eu:8013/waterfall
