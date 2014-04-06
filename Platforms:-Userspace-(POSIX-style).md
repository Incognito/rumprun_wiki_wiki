Support for POSIX-style userspace platforms is included directly
in the NetBSD source tree under
[src/lib/librumpuser](http://nxr.netbsd.org/xref/src/lib/librumpuser/).
Currently, support is available for Linux, Android, the BSDs and Cygwin.
There is also nascent support for Mac OS X.

The easiest way to build rump kernels for userspace targets is to use
[buildrump.sh](http://repo.rumpkernel.org/buildrump.sh), either
natively for fast systems or via a cross compiler for slower systems.

History
-------

The original platform for rump kernels was userspace on NetBSD,
first published in August 2007.  This history of userspace roots
still shows in rump kernels with the hypercall interface being
called _rumpuser_.

Two weeks later after support on NetBSD, still August 2007,
initial support for Linux was added.  Back then, building rump
kernels for NetBSD was easy, while building for Linux took a huge
deal of manual work.  Linux support phased in and out of bitrot over
the years, with some adventurous individuals occasionally contributing
patches.

One notable point in supporting rump kernels on non-NetBSD platforms was
the [pkgsrc package](http://ftp.netbsd.org/pub/pkgsrc/current/pkgsrc/misc/rump/README.html)
from 2009.  For the first time, the package made it easy for anyone to
build and run rump kernels on for example Linux and FreeBSD.

Though pkgsrc made building rump kernels on non-NetBSD easy, it still required
an expert to update the NetBSD source tree that the package built.  The
next turning point came in 2012 with [buildrump.sh](http://repo.rumpkernel.org/buildrump.sh),
which strived to reach the same level of usability as NetBSD's legendary
build script, _build.sh_.  With the buildrump.sh script, it finally became
easy to build a given NetBSD source tree as rump kernels for a given target
platform with a single command.