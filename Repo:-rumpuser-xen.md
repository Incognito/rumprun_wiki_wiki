This page describes [rumpuser-xen](http://repo.rumpkernel.org/rumpuser-xen).

This repository contains code that implements the rump kernel hypercall
interfaces for the Xen hypervisor platform.  It enables running rump
kernels and application code as a single-image guest on top of Xen
without having to boot an entire OS.  The advantage of using rump
kernels is being able use unmodified kernel-quality drivers as part of
a single-image application, with the memory footprint being a fraction
of that of a full OS, yet still achieving the isolation provided by Xen.

For applications a POSIX-y interface is provided.  Some applications,
such as those using file systems or sockets interfaces, will more or
less work out-of-the-box.  Limitations include applications which do
not fit into a single-process no-VM model, such as applications using
`fork()` or `execve()`.  These limitations may sometimes be overcome by
various forms of emulation.

See http://www.rumpkernel.org/ for more information on rump kernels.


Using / Testing
---------------

To build, clone this repository and run the following command.  You
need Xen headers for a successful build (e.g. on Ubuntu they're in
the `libxen-dev` package).

	./buildxen.sh

To run, use the standard Xen tools:

	xl create -c domain_config

Check out `domain_config` to change which tests/demos are run.
By default, a httpd will be run.  You will need a Xen network
setup for it to work.

Debugging
---------

Debugging the rump kernel Xen stack is described on a separate
page: [[Howto:-Debugging-rumpuser-xen-with-gdb]].