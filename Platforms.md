As opposed to the laborious methods of writing drivers from scratch or
case-by-case porting and maintaining drivers from an established OS, the
drivers provided by rump kernels are 100% unmodified over the upstream
NetBSD tree.  The drivers are adapted to the target platform by a compact,
high-level hypercall integrated.


Supported platforms
-------------------

The currently supported platforms are:

* [[Userspace (POSIX style)|Platform: Userspace (POSIX Style)]],
  including Linux, Android, NetBSD, FreeBSD, OpenBSD, Dragonfly
  BSD, Solaris (+ derivates) and Windows (via Cygwin).
* [[Linux kernel|Platform: Linux kernel]]
* [Xen DomU](https://github.com/rumpkernel/wiki/wiki/Platform:-Xen-DomU)
* [Genode OS Framework](https://github.com/rumpkernel/wiki/wiki/Platform:-Genode-OS-Framework)


Hypercalls
----------

There are two facets for hypercalls.  First, there are basic hypercalls
which allow a rump kernel to run on the given platform.  These include,
and actually are by a large part limited to, memory allocation and
integrating with the platform's thread scheduler.  This hypercall
interface is known as _rumpuser_, due to userspace being the first
supported platform (the name stuck).  The rumpuser interface is documented on the
[man page](http://man.NetBSD.org//cgi-bin/man-cgi?rumpuser++NetBSD-current).

Second, there are hypercalls which allow drivers to perform I/O
operations.  These hypercalls can be implemented on a driver-by-driver
basis.  As an example of an I/O hypercall, consider the case where a
rump kernel is used to provide the TCP/IP stack as a driver.  Sending
and receiving packets is done via hypercalls.  Even then, there are 
two options: virtualized and physical.  In the virtualized version, 
the hypercalls access a service provided by the platform (e.g. tap).
In case of a physical driver, the hypercalls allow the rump kernel to
access the hardware bus (e.g. PCI) where the device (NIC) resides.

_Note_: due to historic reasons, the rumpuser interface provides support for
"Files and I/O" (cf. the man page).  This part of rumpuser is pencilled
to made consistent with other I/O hypercalls in the
[next hypercall revision](https://github.com/rumpkernel/buildrump.sh/issues/59).

Integrating
-----------

Implementing the abovementioned hypercalls will allow a rump kernel to
run on a platform, and if used as a "full stack" solution where a rump
kernel is accessed via the syscall service layer, no further work is
required.

In case rump kernels are to be integrated on a driver level, it must be
done in accordance with the existing abstractions of the target platform.
For example, [p2k](http://nxr.netbsd.org/xref/src/lib/libp2k/)
integrates file system drivers provided by rump kernels
as FUSE-like userspace servers.  On the end of the spectrum,
[sockin](http://nxr.netbsd.org/xref/src/sys/rump/net/lib/libsockin/)
integrates rump kernels to the platform's networking, so as to enable running
network protocol drivers such as NFS without requiring a full networking
stack -- in other words, the rump kernel uses the same IP addresses as everything else on the platform.