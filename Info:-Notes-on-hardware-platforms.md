This page documents necessary flags and tips for building rump kernels for "exotic" hardware platforms.

Raspberry Pi
============

In case you get errors for unsupported assembly instructions, run buildrump.sh with
`-F ACFLAGS=-march=armv6k`.  This is required because your compiler's target and the
NetBSD source code are not in perfect harmony.