Travis CI (Linux/x86_64):

* [static and dynamic builds of buildrump.sh/POSIX, clang + gcc](https://travis-ci.org/rumpkernel/buildrump.sh) ![Build Status](https://travis-ci.org/rumpkernel/buildrump.sh.png?branch=master)
* [rump kernels on the Xen hypervisor](https://travis-ci.org/rumpkernel/rumpuser-xen) ![Build Status](https://travis-ci.org/rumpkernel/rumpuser-xen.png?branch=master)
* [rumprun](https://travis-ci.org/rumpkernel/rumprun) ![Build Status](https://travis-ci.org/rumpkernel/rumprun.png?branch=master)
* [DPDK TCP/IP stack driver](https://travis-ci.org/rumpkernel/dpdk-rumptcpip) ![Build Status](https://travis-ci.org/rumpkernel/dpdk-rumptcpip.png?branch=master)
* [netmap TCP/IP stack driver](https://travis-ci.org/rumpkernel/netmap-rumptcpip) ![Build Status](https://travis-ci.org/rumpkernel/netmap-rumptcpip.png?branch=master)
* [PCI drivers in userspace](https://travis-ci.org/rumpkernel/pci-userspace) ![Build Status](https://travis-ci.org/rumpkernel/pci-userspace.png?branch=master)
* [rumpfiber hypercall layer](https://travis-ci.org/rumpkernel/rumpfiber) [![Build Status](https://travis-ci.org/rumpkernel/rumpfiber.png)](https://travis-ci.org/rumpkernel/rumpfiber)

Live Travis reports are sent to __#rumpkernel-builds__ on irc.freenode.net.

Buildbot:

* [buildrump.sh stable, multiple operating systems and architectures](http://build.myriabit.eu:8011/waterfall)
* [buildrump.sh NetBSD HEAD, multiple operating systems and architectures](http://build.myriabit.eu:8012/waterfall) (*)
* [ljsyscall, includes rump kernel tests on various platforms](http://build.myriabit.eu:8010/waterfall)
* [rumprun, multiple platforms](http://build.myriabit.eu:8013/waterfall)

\* since these builds are not against a "known good" timestamp of NetBSD sources, there may be transient failures due to problems in the NetBSD tree.
