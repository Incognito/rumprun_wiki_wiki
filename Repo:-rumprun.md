The page describes the [rumprun
repository](http://repo.rumpkernel.org/rumprun), which provides the
rumprun software stack for various platforms.  The rumprun stack provides
a near-full POSIX-y application interface on top of a rump kernel.  This
stack can be bundled with real-world applications using `app-tools`
to form _unikernels_.

Currently supported are baremetal/x86 and Xen/x86+x64.  The merge is
a recent development, and the bits between the platforms are slowly
being unified.

The advantage of the rumprun stack is the ability to use unmodified
kernel-quality drivers as part of a single-image application, with
the memory footprint being a fraction of that of a full OS, yet still
achieving the isolation and multiplicity of the platforms.  Applications,
such as those using file systems or sockets interfaces or pthreads, will
more or less work out-of-the-box.  Limitations include applications which
do not fit into a single-process no-VM model, such as applications using
`fork()` or `execve()`.  These limitations may sometimes be overcome by
various forms of emulation.


baremetal
=========

_XXX: some instructions here need updating after repo unification_

The baremetal platform provides support on raw hardware, and by extension
most hypervisors on the cloud.  The main difference between running
on hardware or hypervisors is approach to I/O.  On actual bare metal
hardware drivers get used, while on a cloud hypervisor approaches such
as _virtio_ come into play.

Building
--------

Generally, assuming you are building on x86, the following should work:

```
sh build-rr.sh baremetal -- -F ACLFLAGS=-m32
```

Non-x86 targets
-------------

Other targets than x86 are not yet supported, so if you want to build
for those, you need to write the small amount of necessary machine
dependent code.  (patches very welcome ;-)

Creating a bootable ISO image with grub
---------------------------------------

Run `make iso`.  You will need `xorriso` and `grub-mkrescue` installed
on your build host.

VirtualBox
----------

If you want to run the iso in VirtualBox be sure to go into the VM
settings -> Network -> Adapter 1 -> Advanced -> Adapter Type and select
the 82540EM, or you can try one of the other Intel ones.

Running
-------

Run the resulting image just like you would any other OS with e.g. QEMU
or VirtualBox.

Alternatively, you can copy the result of `make iso` to a USB flash
drive and boot on hardware.  Notably, by default there is only very
limited network driver support in the default image, so do not expect
things to automatically work on any system you can find.


Xen
===


Using / Testing
---------------

_XXX: some instructions here need updating after repo unification_

To build, clone this repository and run the following command.  You
need Xen headers for a successful build (e.g. on Ubuntu they're in
the `libxen-dev` package).

        ./build-rr.sh xen

To run, use the `rumprun` tool:

        ./app-tools/rumprun xen -i tests/hello/hello

This will run a simple "Hello, World" demo as a domU, attaching to its console.

Running the `rumprun` tool with no parameters will display a short usage
message .  More demos can be found under `tests/`, and a demo of running
an unmodified httpd can be found at https://github.com/mato/rump-mathopd.

Debugging
---------

Debugging the rump kernel Xen stack is described on a separate
page: [[Howto:-Debugging-rumprun-xen-with-gdb]].
