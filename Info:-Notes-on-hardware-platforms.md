This page documents necessary flags and tips for building rump kernels for "exotic" hardware platforms.

Raspberry Pi
============

In case you get errors for unsupported assembly instructions (e.g. `ldrex`), run buildrump.sh with
`-F ACFLAGS=-march=armv6k`.  This is required because your compiler's target and the
NetBSD source code are not in perfect harmony.  Note: earlier versions of buildrump.sh used to
default all ARM6 builds to armv6k, but this default has been removed.

ARM Thumb builds
================

If you do a build with Thumb instructions you will need to use `-F ACFLAGS='-mthumb -mthumb-interwork'` as some files are still built with arm instructions and so you need the interop flag.
