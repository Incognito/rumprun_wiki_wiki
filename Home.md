Rump kernels provide portable, componentized, kernel quality drivers
such as file systems, POSIX system call handlers, PCI device drivers,
a SCSI protocol stack and the TCP/IP stack.
The fundamental enabling technology is the _anykernel_ architecture 
of NetBSD, which allows the use of unmodified NetBSD kernel drivers.

Several [[platforms]] are already supported, e.g. userspace (including Linux, Android, BSDs, etc.),
the Xen hypervisor and the Genode OS Framework.  Supporting an entirely new platform is a matter
of implementing the high-level rump kernel hypercall interface.

[The Design and Implementation of the Anykernel and Rump Kernels](http://lib.tkk.fi/Diss/2012/isbn9789526049175/isbn9789526049175.pdf) (2012) describes the fundamental operating principles and terminology.  You can find out more on the pages for [[software|Info: Software, scripts, etc.]], [[articles|Info: External articles, tutorials and howto's]] and [[publications & talks|Info: Publications and Talks]].

Editing this wiki is open to everyone.  Please check out the [wiki guidelines](http://repo.rumpkernel.org/wiki) before editing.

## Discuss rump kernels

Mailing list: rumpkernel-users@lists.sourceforge.net.  You can [subscribe here](https://lists.sourceforge.net/lists/listinfo/rumpkernel-users) or browse the [archives](http://blog.gmane.org/gmane.comp.rumpkernel.user).

IRC: **\#rumpkernel** on **irc.freenode.net**.

Twitter: [@rumpkernel](https://twitter.com/rumpkernel)


## Getting started

Follow our [[tutorial|Tutorial:-Getting-Started]] to get yourself acquainted with some basic concepts and commands.