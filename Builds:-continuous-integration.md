There are various continuous integration builds.

## buildrump.sh

These tests ensure that rump kernels for POSIX hosts can be built and used on various hosts and on various machine architectures.

Travis CI, static and dynamic builds on x86_64 with clang and gcc
* https://travis-ci.org/rumpkernel/buildrump.sh ![Build Status](https://travis-ci.org/rumpkernel/buildrump.sh.png?branch=master)

Buildbot builds of all branches, on NetBSD, Linux, OpenBSD, FreeBSD on x86, x86_64, arm, ppc, ppc64, mips
* http://build.myriabit.eu:8011/waterfall

Buildbot builds against NetBSD head on Linux x86_64, plus cross builds on ppc, arm
* http://build.myriabit.eu:8012/waterfall

## rumpuser-xen

These tests check rump kernels running directly on top of the Xen hypervisor.

Travis CI
* https://travis-ci.org/rumpkernel/rumpuser-xen ![Build Status](https://travis-ci.org/rumpkernel/rumpuser-xen.png?branch=master)

## others

These tests are for various drivers and other software integrating with rump kernels.

Travis CI
* [rumprun](https://travis-ci.org/rumpkernel/rumprun) ![Build Status](https://travis-ci.org/rumpkernel/rumprun.png?branch=master)
* [DPDK TCP/IP stack driver](https://travis-ci.org/rumpkernel/dpdk-rumptcpip) ![Build Status](https://travis-ci.org/rumpkernel/dpdk-rumptcpip.png?branch=master)
* [netmap TCP/IP stack driver](https://travis-ci.org/rumpkernel/netmap-rumptcpip) ![Build Status](https://travis-ci.org/rumpkernel/netmap-rumptcpip.png?branch=master)