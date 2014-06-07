This page documents necessary flags and tips for building rump kernels for "exotic" hardware platforms.

Raspberry Pi
============

In case you get errors for unsupported assembly instructions (e.g. `ldrex`), run buildrump.sh with
`-F ACFLAGS=-march=armv6k`.  This is required because your compiler's target and the
NetBSD source code are not in perfect harmony.  Note: earlier versions of buildrump.sh used to
default all ARM6 builds to armv6k, but this default has been removed.

ARM Thumb builds
================

If you do a build with Thumb instructions you may need to use `-F ACFLAGS='-mthumb -mthumb-interwork'` as some files are still built with arm instructions and so you need the interop flag. This is the default setting on some toolchains.

Gold and Cortex A8
==================

If your toolchain uses the Gold linker and you are building for Armv7, you may get build errors about "cannot scan executable section for Cortex-A8 erratum because it has no mapping symbols." It would be nice to fix these issues, but the fixups only apply to thumb instructions across page boundaries, so if you are doing an arm build you can build with `-F LDFLAGS=-Wl,--no-fix-cortex-a8`.
