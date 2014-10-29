Travis CI (Linux/x86_64):

* [buildrump.sh/POSIX: static & dynamic, clang & gcc](https://travis-ci.org/rumpkernel/buildrump.sh) ![Build Status](https://travis-ci.org/rumpkernel/buildrump.sh.png?branch=master)
* [rumprun Xen](https://travis-ci.org/rumpkernel/rumprun-xen) ![Build Status](https://travis-ci.org/rumpkernel/rumprun-xen.png?branch=master)
* [rumprun POSIX](https://travis-ci.org/rumpkernel/rumprun-posix) ![Build Status](https://travis-ci.org/rumpkernel/rumprun-posix.png?branch=master)
* [rump kernels on bare metal](https://travis-ci.org/rumpkernel/rumpuser-baremetal) ![Build Status](https://travis-ci.org/rumpkernel/rumpuser-baremetal.png?branch=master)
* [DPDK TCP/IP stack driver](https://travis-ci.org/rumpkernel/dpdk-rumptcpip) ![Build Status](https://travis-ci.org/rumpkernel/dpdk-rumptcpip.png?branch=master)
* [netmap TCP/IP stack driver](https://travis-ci.org/rumpkernel/netmap-rumptcpip) ![Build Status](https://travis-ci.org/rumpkernel/netmap-rumptcpip.png?branch=master)
* [PCI drivers in userspace](https://travis-ci.org/rumpkernel/pci-userspace) ![Build Status](https://travis-ci.org/rumpkernel/pci-userspace.png?branch=master)
* [fs-utils](https://travis-ci.org/rumpkernel/fs-utils) ![Build Status](https://travis-ci.org/rumpkernel/fs-utils.png?branch=master)

Live Travis reports are sent to __#rumpkernel-builds__ on irc.freenode.net.

Buildbot:

* [buildrump.sh stable, multiple operating systems and architectures](http://build.myriabit.eu:8011/waterfall)
* [buildrump.sh NetBSD HEAD, multiple operating systems and architectures](http://build.myriabit.eu:8012/waterfall) (*)
* [ljsyscall, includes rump kernel tests on various platforms](http://build.myriabit.eu:8010/waterfall)
* [rumprun-posix, multiple platforms](http://build.myriabit.eu:8013/waterfall)

\* since these builds are not against a "known good" timestamp of NetBSD sources, there may be transient failures due to problems in the NetBSD tree.
