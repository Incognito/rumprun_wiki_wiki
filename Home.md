Rump kernels provide portable, componentized, kernel quality drivers
such as file systems, POSIX system call handlers, PCI device drivers,
a SCSI protocol stack and the TCP/IP stack.
The fundamental enabling technology is the _anykernel_ architecture 
of NetBSD, which allows the use of unmodified NetBSD kernel drivers.

Several [[platforms]] are already supported, e.g. userspace (including Linux, Android, BSDs, etc.),
the Xen hypervisor and the Genode OS Framework.  Supporting an entirely new platform is a matter
of implementing the high-level rump kernel hypercall interface.

The book
[The Design and Implementation of the Anykernel and Rump Kernels](http://lib.tkk.fi/Diss/2012/isbn9789526049175/isbn9789526049175.pdf) (2012) describes fundamental operating principles and terminology.  You can find out more on the pages for [[software|Info: Software, scripts, etc.]], [[articles|Info: External articles, tutorials and howto's]] and [[publications & talks|Info: Publications and Talks]].

## Discuss

Mailing list: rumpkernel-users@lists.sourceforge.net.  You can [subscribe here](https://lists.sourceforge.net/lists/listinfo/rumpkernel-users) or browse the [archives](http://blog.gmane.org/gmane.comp.rumpkernel.user).

IRC: **\#rumpkernel** on **irc.freenode.net**.

Twitter: [@rumpkernel](https://twitter.com/rumpkernel)


## Getting started

The easiest way to try out rump kernels is to start in
userspace with [_buildrump.sh_](http://repo.rumpkernel.org/buildrump.sh).
Clone the repository and run the script without arguments.
The script will do a build that allows you to run rump kernels
in userspace on your host.  Then get [_rumprun_](http://repo.rumpkernel.org/rumprun).  It
provides familiar utilities such as `ls`, `ifconfig`, `sysctl`, etc.
which allow you to access, configure and try out rump kernels.