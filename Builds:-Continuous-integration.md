Travis CI (build host is Linux/x86_64, target depends on repo):

* [buildrump.sh/POSIX: static & dynamic, clang & gcc](https://travis-ci.org/rumpkernel/buildrump.sh) ![Build Status](https://travis-ci.org/rumpkernel/buildrump.sh.png?branch=master)
* [rumprun (hw and Xen platforms)](https://travis-ci.org/rumpkernel/rumprun) ![Build Status](https://travis-ci.org/rumpkernel/rumprun.png?branch=master)
* [rumpctrl](https://travis-ci.org/rumpkernel/rumpctrl) ![Build Status](https://travis-ci.org/rumpkernel/rumpctrl.png?branch=master)
* [network interface driver for DPDK backend](https://travis-ci.org/rumpkernel/drv-netif-dpdk) ![Build Status](https://travis-ci.org/rumpkernel/drv-netif-dpdk.png?branch=master)
* [network interface driver for netmap backend](https://travis-ci.org/rumpkernel/drv-netif-netmap) ![Build Status](https://travis-ci.org/rumpkernel/drv-netif-netmap.png?branch=master)
* [PCI drivers in userspace](https://travis-ci.org/rumpkernel/pci-userspace) ![Build Status](https://travis-ci.org/rumpkernel/pci-userspace.png?branch=master)
* [fs-utils](https://travis-ci.org/rumpkernel/fs-utils) ![Build Status](https://travis-ci.org/rumpkernel/fs-utils.png?branch=master)
* [rump-pktgenif](https://travis-ci.org/rumpkernel/rump-pktgenif) ![Build Status](https://travis-ci.org/rumpkernel/rump-pktgenif.png?branch=master)

Live Travis reports are sent to __#rumpkernel-builds__ on irc.freenode.net.

Buildbot:

* [buildrump.sh stable, multiple operating systems and architectures](http://build.myriabit.eu:8011/waterfall)
* [NetBSD HEAD, buildrump.sh & rumpctrl, multiple host systems and architectures](http://build.myriabit.eu:8012/waterfall) (*)
* [ljsyscall, includes rump kernel tests on various platforms](http://build.myriabit.eu:8010/waterfall)
* [rumpctrl, multiple platforms](http://build.myriabit.eu:8013/waterfall)

\* hourly runs with NetBSD HEAD.  Since these runs are not against a "known good" timestamp of NetBSD sources, there may be transient failures.
