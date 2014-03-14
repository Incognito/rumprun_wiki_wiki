# The Anykernel and Rump Kernels

## About

A driver abstracts an underlying entity. For example, a TCP/IP driver
abstracts the details required to perform networking, the Fast File
System (FFS) driver abstracts how the file system blocks are laid out on
the storage medium, and a PCI network card driver abstracts how to
access device registers to send and receive packets. The kernel
architecture controls how kernel drivers run with respect to other
system components. Some examples of kernel architectures are the
monolithic kernel, microkernel and exokernel. In contrast to the above
architectures, NetBSD is an *anykernel*. This means that some kernel
drivers can be run according to any kernel architecture instead of being
limited to a single one.

<!--
    TODO
    ![](rumparch.png)
-->

When a driver is not run as part of the monolithic kernel, e.g. when it
is run as a microkernel style server, the driver is hosted in a *rump
kernel*. A rump kernel is an ultralightweight virtualized kernel running
on top of high-level hypercall interface. Instead of a low-level
hypercall API typically seen with operating systems with operations such
as "modify page table", the rump kernel hypercall API provides
high-level operations such as "run this code in a thread".

Currently, four open source implementations of the rump kernel hypercall interface exist:

-   The POSIX (i.e. userspace) implementation is included in the NetBSD tree and allows
    rump kernels to run in processes on most operating systems such as NetBSD, Linux and Solaris.
-   The [Xen implementation](https://github.com/rumpkernel/rumpuser-xen) allows running
    rump kernels directly as Xen DomU's without an intermediate operating system.
-   The [Linux kernel hypercall implementation](https://github.com/rumpkernel/rumpuser-linuxkernel)
    allows rump kernels to run inside the Linux kernel.
-   The [Genode](http://genode.org/) hypercall layer implementation is shipped with Genode OS.  See their
    website for further details.

Rump kernels are radically different from OS virtualization technologies
such as KVM, containers and usermode operating systems. A rump kernel
does not support hosting application processes because a rump kernel is
aimed at virtualizing kernel drivers and application virtualization
would be pure overhead. Instead, existing entities such as processes
from a hosting OS are used as clients for the rump kernel ("application"
in the figure).

As a result of the above design choices, rump kernels are extremely
lightweight. The bootstrap time for rump kernels on POSIX hosts is
measured in milliseconds and memory footprint in 100kB's. This means
that a rump kernel can be bootstrapped for example as part of a command
line tool for virtually no cost or user impact. Rump kernels also
mandate very little from the hypercall implementation meaning that
rump kernels, and by extension NetBSD kernel drivers, can be hosted in
virtually any environment -- for example, rump kernels do not require
a platform with an MMU.

Use cases for rump kernels include:

-   **Code reuse**: kernel drivers can be reused without having to run a
    whole OS. For example, a full-featured TCP/IP stack (IPv6, IPSec,
    etc.) can be included in an embedded appliance without having to
    write the stack from scratch or waste resources on running an entire
    OS.
-   **Kernel driver virtualization**: every rump kernel has its own
    state. Furthermore, the functionality offered by multiple rump
    kernels running on the same host does not need to be equal. For
    example, multiple different networking stacks optimized for
    different purposes are possible.
-   **Security**: when hosted on a POSIX system, a rump kernel runs in
    its own instance of a userspace process. For example, it is widely
    published that file system drivers are vulnerable to untrusted file
    system images. Unlike on other general purpose operating systems, on
    NetBSD it is possible to mount untrusted file systems, such as those
    on a USB stick, in an isolated server with the kernel file system
    driver. This isolates attacks and prevents kernel compromises while
    not requiring to maintain separate userspace implementations of the
    file system drivers or use other resource-intensive approaches such
    as virtual machines.
-   **Easy prototyping and development**: kernel code can be developed
    as a normal userspace application. Once development is finished, the
    code can simply be complied into the kernel. This is a much more
    convenient and straightforward approach to kernel development than
    the use of virtual machines.
-   **Safe testing**: kernel code can be tested in userspace on any host
    without risk of the test host being affected. Again, virtual
    machines are not required.

## Further Reading

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


### Software using rump kernels

While the NetBSD source tree hosts the base kernel drivers and hypercall
implementation, more I/O drivers, infrastructure scripts and hypercall
implementations are hosted elsewhere.  Most of the code is hosted
under the [rump kernels](https://github.com/rumpkernel/) organization
on github.  Some highlights include:

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

### Conference publications and talks

-   "Rump Kernels, Just Components" talks about rump kernels as reusable
    and platform-agnostic drivers.  The intended audience is developers.  The
    [video](http://video.fosdem.org/2014/H2214/Sunday/Rump_Kernels_Just_Components.webm)
    and [slides](https://fosdem.org/2014/schedule/event/01_uk_rump_kernels/attachments/slides/398/export/events/attachments/01_uk_rump_kernels/slides/398/fosdem2014.pdf) are available.
    Presented at FOSDEM 2014 (Microkernel devroom).
-   "The Anykernel and Rump Kernels" gives a general overview and
    demonstrates rump kernels on Windows and in Firefox. The
    [video](http://video.fosdem.org/2013/maintracks/K.1.105/The_Anykernel_and_Rump_Kernels.webm),
    [slides](https://fosdem.org/2013/schedule/event/operating_systems_anykernel/attachments/slides/244/export/events/attachments/operating_systems_anykernel/slides/244/fosdem2013_rumpkern.pdf)
    and an
    [interview](https://archive.fosdem.org/2013/interviews/2013-antii-kantee/)
    are available. Presented at FOSDEM 2013 (Operating Systems track).
-   "Rump Device Drivers: Shine On You Kernel Diamond" describes device
    driver and USB. The
    [paper](http://ftp.NetBSD.org/pub/NetBSD/misc/pooka/tmp/rumpdev.pdf)
    and [video presentation](http://www.youtube.com/watch?v=3AJNxa33pzk)
    are available. Presented at AsiaBSDCon 2010.

-   "Fs-utils: File Systems Access Tools for Userland" describes
    fs-utils, an mtools-like utility kit which uses rump kernel file
    systems as a backend. The
    [paper](http://www.ukuug.org/events/eurobsdcon2009/papers/ebc09_fs-utils.pdf)
    is available. Presented at EuroBSDCon 2009.
-   "Rump File Systems: Kernel Code Reborn" describes kernel file system
    code and its uses in userspace. The
    [paper](http://usenix.org/events/usenix09/tech/full_papers/kantee/kantee.pdf)
    and
    [slides](http://usenix.org/events/usenix09/tech/slides/kantee.pdf)
    are available. Presented at the 2009 USENIX Annual Technical
    Conference.
-   "Kernel Development in Userspace - The Rump Approach" describes
    doing kernel development with rump kernels. The
    [paper](http://www.bsdcan.org/2009/schedule/attachments/104_rumpdevel.pdf)
    and
    [slides](http://www.bsdcan.org/2009/schedule/attachments/105_bsdcan09-kantee.pdf)
    are available. Presented at BSDCan 2009.
-   "Environmental Independence: BSD Kernel TCP/IP in Userspace"
    describes networking in rump kernels. The
    [paper](http://2009.asiabsdcon.org/papers/abc2009-P5A-paper.pdf) and
    [video presentation](http://www.youtube.com/watch?v=RxFctq8A0WI) are
    available. Presented at AsiaBSDCon 2009.

## Discuss

Any topic related to rump kernels can be discussed on the
[rumpkernel-users mailing
list](https://lists.sourceforge.net/lists/listinfo/rumpkernel-users).
Alternatively, you can use a NetBSD mailing which is related to a
specific subtopic.

The IRC channel for rump kernels is **\#rumpkernel** on
**irc.freenode.net**.
