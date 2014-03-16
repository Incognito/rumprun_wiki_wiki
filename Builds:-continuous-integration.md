Travis CI:
* [static and dynamic builds for buildrump.sh/POSIX, x86_64 w/ clang + gcc](https://travis-ci.org/rumpkernel/buildrump.sh) ![Build Status](https://travis-ci.org/rumpkernel/buildrump.sh.png?branch=master)
* [rump kernels on the Xen hypervisor](https://travis-ci.org/rumpkernel/rumpuser-xen) ![Build Status](https://travis-ci.org/rumpkernel/rumpuser-xen.png?branch=master)
* [rumprun](https://travis-ci.org/rumpkernel/rumprun) ![Build Status](https://travis-ci.org/rumpkernel/rumprun.png?branch=master)
* [DPDK TCP/IP stack driver](https://travis-ci.org/rumpkernel/dpdk-rumptcpip) ![Build Status](https://travis-ci.org/rumpkernel/dpdk-rumptcpip.png?branch=master)
* [netmap TCP/IP stack driver](https://travis-ci.org/rumpkernel/netmap-rumptcpip) ![Build Status](https://travis-ci.org/rumpkernel/netmap-rumptcpip.png?branch=master)

Buildbot builds of all buildrump.sh branches, on NetBSD (i386, x86_64), Linux (i386, x86_64, arm, pcc32, ppc64, mips), OpenBSD (x86_64), FreeBSD (x86_64):
* http://build.myriabit.eu:8011/waterfall

Buildbot builds against NetBSD HEAD on Linux x86_64, plus cross builds on ppc, arm.  Note since these builds are not against a "known good" timestamp of NetBSD sources, there may be transient failures due to problems in the NetBSD tree:
* http://build.myriabit.eu:8012/waterfall