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

Tested hosts
============

Continuous testing and integration for userspace builds is available at http://builds.rumpkernel.org.

Tested machine architectures include _x86_ (32/64bit), _ARM_, _PowerPC_
(32/64bit), _MIPS_ (32bit) and _UltraSPARC_ (32/64bit).

Examples of hosts buildrump.sh has been tested on are as follows:

- Linux
    - Linux Gallifrey 2.6.35.14-106.fc14.x86_64 #1 SMP Wed Nov 23 13:07:52 UTC 2011 x86_64 x86_64 x86_64 GNU/Linux (with seLinux in permissive mode, __amd64__)
    - Linux vyrnwy 3.6.2-1.fc16.x86_64 #1 SMP Wed Oct 17 05:30:01 UTC 2012 x86_64 x86_64 __x86_64__ GNU/Linux (Fedora release 16 with read-only /usr/src via NFS)
    - Linux void-rpi 3.6.11_1 #1 PREEMPT Tue Feb 19 17:40:24 CET 2013 armv6l GNU/Linux (Void, __Raspberry Pi, evbarm__)
    - Linux braniac 3.9.9-1-ARCH #1 SMP PREEMPT Wed Jul 3 22:45:16 CEST 2013 x86_64 GNU/Linux (Arch Linux, __amd64__, gcc 4.8.1)
    - Linux pike 3.6.7-4.fc17.ppc64 #1 SMP Thu Dec 6 06:41:58 MST 2012 ppc64 ppc64 ppc64 GNU/Linux (Fedora, __ppc64__)
    - Linux 172-29-171-95.dal-ebis.ihost.com 2.6.32-358.el6.ppc64 #1 SMP Tue Jan 29 11:43:27 EST 2013 ppc64 ppc64 ppc64 GNU/Linux (RHEL6, __ppc64__, 64 and 32 bit builds, IBM Virtual Loaner Program)
    - Linux fuloong 3.11.6-gnu #8 PREEMPT Mon Oct 28 23:28:22 GMT 2013 mips64 ICT Loongson-2 V0.3 FPU V0.1 lemote-fuloong-2f-box GNU/Linux (Gentoo, __mips o32 le__)
    - Linux ubnt 2.6.32.13-UBNT #1 SMP Wed Oct 24 01:08:06 PDT 2012 mips64 GNU/Linux (__mips o32 be__)

- Android
    - Android 4.2.2 kernel 3.4.5 ARMv7 Processor rev 2 (v7l) (__arm__)

- DragonFly BSD
    - DragonFly  3.2-RELEASE DragonFly v3.2.1.9.g80b03f-RELEASE #2: Wed Oct 31 20:17:57 PDT 2012     root@pkgbox32.dragonflybsd.org:/usr/obj/build/home/justin/src/sys/GENERIC  __i386__

- FreeBSD
    - FreeBSD frab 9.1-PRERELEASE FreeBSD 9.1-PRERELEASE #5 r243866: Wed Dec  5 02:15:02 CET 2012     root@vetinari:/usr/obj/usr/src/sys/RINCEWIND  __amd64__ (static rump kernel components, with thanks to Philip for test host access)

- NetBSD
    - NetBSD pain-rustique.localhost 5.1_STABLE NetBSD 5.1_STABLE (PAIN-RUSTIQUE) #5: Wed Feb 16 13:34:14 CET 2011  pooka@pain-rustique.localhost:/objs/kobj.i386/PAIN-RUSTIQUE __i386__

- OpenBSD
    - OpenBSD openbsd.myriabit.eu 5.4 GENERIC#37 __amd64__

- Solaris
    - SunOS hutcs 5.10 Generic_142900-15 sun4v sparc SUNW,T5240 Solaris (needs xpg4/bin/sh, __sparc64__ in 64bit mode, __sparc__ in 32bit mode)
    - SunOS pkgsrc-dev 5.11 joyent_20120126T071347Z i86pc i386 i86pc (with thanks to Jonathan for test host access, __amd64__ in 64bit mode, __i386__ in 32bit mode)

There is also initial support for Cygwin, but it will not work
out-of-the-box due to object format issues (ELF vs. PE-COFF).
Mac OS X is likely to require support for its linker.
