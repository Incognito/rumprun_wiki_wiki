Welcome to the main wiki for rump kernels.  See [here](https://github.com/rumpkernel/wiki/wiki/_pages)
for an overview of the pages on this wiki.  The rest of this page gives a short introduction to rump kernels with links to further details.

## The Anykernel and Rump Kernels

A driver abstracts an underlying entity. For example, a TCP/IP driver
abstracts the details required to perform networking, the Fast File
System (FFS) driver abstracts how the file system blocks are laid out on
the storage medium, and a PCI network card driver abstracts how to
access device registers to send and receive packets.

The *anykernel* architecture of NetBSD allows running unmodified kernel drivers
outside of the regular operating system kernel as *rump kernels*.  A rump kernel
is executed in the thread context of the host, thus allowing *integration* of
kernel drivers instead of virtualization.  To request services such as memory or
I/O access, a rump kernel uses a high-level *hypercall interface*.

For a rump kernel to able to run on a platform, a hypercall implementation for the
platform must exist.  Currently, there are four open source implementations of the rump kernel hypercall
interface:

-   The POSIX (i.e. userspace) implementation is included in the NetBSD tree and allows
    rump kernels to run in processes on most operating systems such as NetBSD, Linux and Solaris.
-   The [Xen implementation](https://github.com/rumpkernel/rumpuser-xen) allows running
    rump kernels directly as Xen DomU's without an intermediate operating system.
-   The [Linux kernel hypercall implementation](https://github.com/rumpkernel/rumpuser-linuxkernel)
    allows rump kernels to run inside the Linux kernel.
-   The [Genode](http://genode.org/) hypercall layer implementation is shipped with Genode OS.  See their
    [documentation]
    (http://genode.org/documentation/release-notes/14.02#NetBSD_file_systems_using_rump_kernels)
    for further details.

## Discuss

Any topic related to rump kernels can be discussed on the
[rumpkernel-users mailing
list](https://lists.sourceforge.net/lists/listinfo/rumpkernel-users).

The IRC channel for rump kernels is **\#rumpkernel** on
**irc.freenode.net**.


## Further Reading and Links

### Book

The following book is the definitive guide to the anykernel and rump
kernels and supercedes all earlier publications and terminology on
the subject.

-   [Flexible Operating System Internals: The Design and Implementation
    of the Anykernel and Rump
    Kernels](http://lib.tkk.fi/Diss/2012/isbn9789526049175/isbn9789526049175.pdf)

Note that the book was finalized in summer 2012, so while the fundamentals
are still accurate, some of the problems described in "Future Work"
have already been solved.  Check out the links below.


### Software, scripts, etc.

-   [Scripts for building rump kernels for POSIX
    systems](https://github.com/rumpkernel/buildrump.sh)
-   The [rumprun](https://github.com/rumpkernel/rumprun/) package
    allows portable building and running of unmodified NetBSD userspace
    applications -- extremely useful for configuring rump kernels (e.g.
    network interfaces and routing tables)
-   [Rump kernel hypercall implementation for Xen; rump kernels as Xen
    DomU's](https://github.com/rumpkernel/rumpuser-xen)
-   [fs-utils: File system image access
    utilities](https://github.com/stacktic/fs-utils)
-   Fast userspace packet processing: TCP/IP stack for use with
    [DPDK](https://github.com/rumpkernel/dpdk-rumptcpip), 
    [netmap](https://github.com/rumpkernel/netmap-rumptcpip) or
    [Snabb Switch](https://github.com/anttikantee/snabbswitch/tree/rumpkernel/)

### Articles, Tutorials & Howtos

-   [Running rump kernels and applications on Xen without a full
    OS](http://blog.NetBSD.org/tnf/entry/running_applications_on_the_xen)
-   [PCI device driver support in rump kernels on
    Xen](http://blog.NetBSD.org/tnf/entry/pci_driver_support_for_rump)
-   [Experiment with a rump kernel hypervisor for the Linux
    kernel](http://blog.NetBSD.org/tnf/entry/a_rump_kernel_hypervisor_for)
    (allows rump kernels to run *in* the Linux kernel)
-   [Experiment on compiling rump kernels to javascript and running them
    in the
    browser](http://blog.NetBSD.org/tnf/entry/kernel_drivers_compiled_to_javascript)
-   [Kernel Servers using
    Rump](http://www.NetBSD.org/docs/rump/sysproxy.html)
-   [Tutorial On Rump Kernel Servers and
    Clients](http://www.NetBSD.org/docs/rump/sptut.html)
-   [Revolutionizing Kernel Development: Testing With
    Rump](http://blog.NetBSD.org/tnf/entry/revolutionizing_kernel_development_testing_with)



