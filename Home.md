Welcome to the main wiki for rump kernels.  The this page gives a short introduction to rump kernels.  You will find more detailed information from [the wiki pagelist](https://github.com/rumpkernel/wiki/wiki/_pages).


## Discuss

Mailing list: rumpkernel-users@lists.sourceforge.net.  You can [subscribe here](https://lists.sourceforge.net/lists/listinfo/rumpkernel-users) or browse the [archives](http://blog.gmane.org/gmane.comp.rumpkernel.user).

IRC channel: **\#rumpkernel** on **irc.freenode.net**.


## The Anykernel and Rump Kernels

A driver abstracts an underlying entity. For example, a TCP/IP driver
abstracts the details required to perform networking, the Fast File
System (FFS) driver abstracts how the file system blocks are laid out on
the storage medium, and a PCI network card driver abstracts how to
access device registers to send and receive packets.

The *anykernel* architecture of NetBSD allows running unmodified kernel drivers
outside of the operating system kernel as *rump kernels*.  A rump kernel
is executed in the thread context of the host, thus allowing full *integration* of
kernel drivers.  For example,
it is possible to integrate the NetBSD TCP/IP stack into an existing product as a
rump kernel without first having to extract the TCP/IP stack from the NetBSD kernel.

To request services such as memory or
I/O access, a rump kernel uses a high-level *hypercall interface*.
Currently, there are four open source implementations:

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

The book
[The Design and Implementation of the Anykernel and Rump Kernels](http://lib.tkk.fi/Diss/2012/isbn9789526049175/isbn9789526049175.pdf) (2012) describes fundamental operating principles and terminology.  Note that especially portability has been vastly improved since the book was published.

You can find out more on the pages for [software](https://github.com/rumpkernel/wiki/wiki/Software,-scripts,-etc.), [articles](https://github.com/rumpkernel/wiki/wiki/Links-to-external-articles,-tutorials-and-howto%27s) and [publications & talks](https://github.com/rumpkernel/wiki/wiki/Publications-and-Talks).