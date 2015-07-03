The page describes the [rumprun
repository](http://repo.rumpkernel.org/rumprun).
If you are completely unfamiliar the rump kernel ecosystem, we suggest following
the [[Getting Started Tutorial|Tutorial:-Getting-Started]] before attempting to
read the rest of this page.

The rumprun repository provides the
rumprun unikernel for various platforms.  Rumprun uses the drivers offered
by rump kernels, adds a libc and an application environment on top, and
provides a toolchain with which to build existing POSIX-y applications
as rumprun unikernels.

The strong point of the rumprun unikernel is that thanks to a foundation
of rump kernels, rumprun will support a great deal of existing
application-level software without the need to port it to rumprun or
rewrite functionality.  Benefits of unikernels are still retained, and
the memory footprint and service bootstrap time is a fraction of that
of a full OS.  Yet, the application performance that rumprun provides
can exceed that of a full OS.

Limitations include applications which do not fit into a single-process
no-VM model, such as applications using `fork()` or `execve()`.  Another
limitation is that the build system used by the application must support
cross-compilation.  If necessary, these limitations may typically be
overcome with a small amount of porting work.

Platforms currently support by rumprun are hw/x86+x64 and Xen/x86+x64,
with more being worked on.  Platform support is modular with the maximal
amount of code shared between platforms, and generally speaking only
bootstrap code and glue to I/O devices and the clock are required for
supporting a new platform.

Major subsections on this page are:
* [[Building|Repo:-rumprun#building]]
* [[Running|Repo:-rumprun#running]]
* [[Platforms|Repo:-rumprun#platforms]]
* [[Debugging|Repo:-rumprun#debugging]]


Building
========

There are three stages to building a runnable rumprun unikernel.  We will
first give an overview of the steps, and detail the procedures in
subsequent sections.

First, you
must build the component libraries for constructing the unikernels.
This is analogous to building the libraries your application requires,
except you will also be building the "kernel" libraries.  This part
of the build process consists invariably of executing one command,
the syntax of which is detailed below.

Second, you must build the application of your choosing and produce the
runnable rumprun unikernel image.  Notably, the build process never
runs on a rump kernel, and therefore the rumprun unikernel is always
cross-compiled.  For software with proper cross-compilation support,
this second phase can be as simple as setting `$CC` and compiling the
software as usual.

Finally, you must "bake" the application(s) into the final runnable image.
The backing stage links in the component libraries for the target configuration
that you want.  For example, consider compiling your application for x86.
If you now bake in PCI device drivers, you can boot your unikernel on a
regular PC.  If you bake in virtio driver, you can use your unikernel on the
cloud.


Building the component libraries
--------------------------------

Short version:

```
CC=target-cc ./build-rr.sh platform
```

For example, if you want to build your unikernels for Xen, and are
happy with using "cc" to do so, simply running `./build-rr.sh xen`
will work.

We do not build our own toolchain, and instead employ wrappers
around the toolchain you supply to `build-rr.sh`.  Specifying `CC`
becomes necessary when you want to build for a non-native machine
architecture.  For example, assuming you are building on x86 and want to
build for some ARM variant, you would supply something in the likes of
`CC=arm-crosscompiler`.  Notably, the `CC` you supply at this stage will
also be used for building the application layers of the rumprun unikernel,
assuming you follow the method described below.

You can also specify additional flags to the toolchain in the following
way:

```
./build-rr.sh platform -- -F ACLFLAGS=flags
```

For example, assuming your toolchain is by default targeting x86_64,
a valid assumption if you are doing development on a 64bit x86 host,
and you want to build 32bit binaries, you would use the following:

```
./build-rr.sh platform -- -F ACLFLAGS=-m32
```


Building application binaries
-----------------------------

After the component libraries and toolchain wrappers for the
platform/machine of your choice are built, you can build runnable
unikernels.  The process will vary from software package to software
package due to different build methodologies, and we cannot give general
instructions.  Cross-compile ready software should more or less build
just as is.

In the `app-tools` directory you will find the toolchain wrappers and some
other helpful wrappers like one for `make` and `configure`.  Using them
you can build cross-compile ready software in the normal fashion.

For example, to compile a program consisting of a single C module
for x86_64, use:

```
x86_64-rumprun-netbsd-gcc -o test test.c
```

Assuming you have a more complex project and a cross-compile respecting
Makefile for it, you can use:

```
x86_64-rumprun-netbsd-make
```

Simple, eh?


Baking
------

Baking is done using the `rumpbake` tool.  It takes the binary produced by
the compiler and produces a runnable image.  The mandatory parameters are the
output image and target name.

For example:
```
rumpbake hw_virtio test.bin test
```

Use `rumpbake list` to list the available targets.


Running
=======

The details of running a unikernel vary from platform to platform.
For example, running a Xen guest requires creating a domain config
file and running `xl`, while running the hw platform in `qemu`
(with or without kvm) requires a different set of options.  We supply the
`rumprun` tool to hide the details and provide a uniform experience for
every platform.

For example, to rumprun a program with an interactive console on
Xen, use:

```
rumprun xen -i prog
```

If "prog" is built for baremtal, you can rumprun it by using `qemu`
as the platform instead of `xen`.


Platforms
=========

Hardware (``hw'')
-----------------

The hw platform provides support on raw hardware, and by extension
most hypervisors on the cloud.  The main difference between running
on hardware or hypervisors is the approach to I/O.  On physical hardware
the hardware drivers get used, while on a cloud hypervisor approaches
such as _virtio_ come into play.


Xen
---

The Xen platform is optimized for running on top of the Xen hypervisor.


Debugging
=========

Generally speaking, use `rumprun -D port` and `target remote:port` in
`gdb`.

More specifically speaking, this section is TODO.
