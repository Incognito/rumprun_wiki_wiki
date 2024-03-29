Wiki pages of repositories:

- [[buildrump.sh|Repo:-buildrump.sh]]
- [[drv-netif-dpdk|Repo:-drv-netif-dpdk]]
- [[drv-netif-netmap|Repo:-drv-netif-netmap]]
- [[fs-utils|Repo:-fs-utils]]
- [[pci-userspace|Repo:-pci-userspace]]
- [[rump-pktgenif|Repo:-rump-pktgenif]]
- [[rumpctrl|Repo:-rumpctrl]]
- [[rumprun|Repo:-rumprun]]

The Big Picture
===============

As you can see from above, repo.rumpkernel.org hosts many repositories.
The remainder of this page is a high-level overview of the functionality
offered by the various repositories, and how they play together.

The goal of rump kernels is to provide drivers which integrate into
any system via a clean, defined interface: the rump kernel hypercall
interface.  These drivers come from the _src-netbsd_ repository.
While the concept of rump kernels is not in any way tied to NetBSD,
currently NetBSD is the only operating system kernel which is an _anykernel_,
i.e. NetBSD supports forming rump kernels out if its drivers.  In the future,
we may offer _src-otheros_ backends as well; the rest of this document
assumes only _src-netbsd_.

To use the drivers, one needs to build the drivers.  Building _src-netbsd_
natively on NetBSD is easy, but we do not wish to limit development
to NetBSD hosts.  To address that, _buildrump.sh_ provides portable
versions of the necessary tools.  For historical reasons, _buildrump.sh_
also enables running rump kernels on POSIX-y hosts.  No matter how you
use rump kernels, you will always need _src-netbsd_ and _buildrump.sh_.

In addition to drivers coming from _src-netbsd_, there are some special
case drivers which are not included in NetBSD.  One such example is the
DPDK network interface driver.  These specialty drivers are provided by
various _drv_ repos, e.g. _drv-netif-dpdk_ and can be linked into rump
kernels to provide access to additional features.

The _rumprun_ repository provides our unikernel platform.  What makes it
different from just the rump kernels provided by _buildrump.sh_?  The rump
kernel is just a kernel, and while it will work for in-kernel workloads
such as routing, and also for applications written against the system call
interfaces, a generic libc-using application will not work.  Rumprun adds
the libc layer along with a toolchain for compiling applications into
runnable unikernels.  Since rump kernels provide a near-complete POSIX-y
system call interface, you can run a great deal of existing, unmodified
application software using the rumprun unikernel suite.

The relationship between the _anykernel_ (src-netbsd), rump kernels
(which are built using buildrump.sh) and the _unikernel_ (rumprun) is
visualized by the following picture:

![anyunirumpkernel](https://raw.githubusercontent.com/rumpkernel/wiki/master/img/anyunirumpkernel.png) 

The _fs-utils_ repo provides a tool suite for accessing file system
images, e.g. __ls__, __cp__, __rm__ etc.  If you are familiar with
mtools, fs-utils provides essentially the same functionality, except
that it work with all file system driver backend supported by rump
kernels and provides the same usage as the regular Unix tools (e.g. the
20-or-so flags of __ls__ are available).  One could call the _fs-utils_
tools unikernels and implement them using _rumprun_.  The reason for the
standalone implementation is historical: fs-utils were created originally
in 2008 when the rumprun unikernel did not exist.  Currently, fs-utils
is not broken so we have not had a dire need to fix it.

TODO: rumpctrl
