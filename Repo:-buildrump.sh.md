This page describes [buildrump.sh](http://repo.rumpkernel.org/buildrump.sh).

The `buildrump.sh` script builds unmodified NetBSD kernel drivers such
as file systems and the TCP/IP stack as components which can be linked
to form *rump kernels*.  These lightweight rump kernels run on
top of a high-level hypercall interface which is straightforward to
implement for most environments.  This repository includes the hypercall
implementation for running in userspace on POSIX hosts, with alternative
implementations such as for the
[Xen hypervisor](https://github.com/rumpkernel/rumpuser-xen/)
and the [Linux kernel](https://github.com/rumpkernel/rumpuser-linuxkernel)
being hosted elsewhere.

In other words, rump kernels enable embedding unmodified kernel drivers
in various environments and using the drivers as services.  Some examples
of how to use these services are as follows:

* [fs-utils](https://github.com/stacktic/fs-utils) uses file
  system drivers to provide applications for accessing file system images
* TCP/IP stack for the [DPDK](https://github.com/rumpkernel/dpdk-rumptcpip)
  and [netmap](https://github.com/rumpkernel/netmap-rumptcpip)
  userspace packet processing frameworks
* [ljsyscall](https://github.com/justincormack/ljsyscall) provides
  a Lua interface to rump kernels, allowing easy access from applications
  written in Lua
* [rumpuser-xen](https://github.com/rumpkernel/rumpuser-xen) enables
  running applications as standalone Xen DomU's (includes libc support)

Rump kernels address the part of the software stack typically handled
by an OS kernel.  For running unmodified userspace applications
against system call services provided by rump kernels, see
[rumprun](https://github.com/justincormack/rumprun/).

For full details on rump kernels, go to http://www.rumpkernel.org/.
For a video overview including various demos, watch the
[FOSDEM 2013 presentation](http://video.fosdem.org/2013/maintracks/K.1.105/The_Anykernel_and_Rump_Kernels.webm).

Discuss buildrump.sh on rumpkernel-users@lists.sourceforge.net
([subscribe](https://lists.sourceforge.net/lists/listinfo/rumpkernel-users)
before posting), or join __#rumpkernel__ on __irc.freenode.net__.

Running `buildrump.sh` requires a network connection for fetching NetBSD
kernel driver source code.  Self-contained archives can be created using
the `tarup.sh` script, and snapshots are available for download from
[here](http://sourceforge.net/projects/rumpkernel/).


Binary packages for userspace
=============================

Check the page [[binary packages|Builds:-Binary-packages#userspace-rump-kernel-components]]
to see if there packages for your platform.


Building from Source Code
=========================

Building from source may be necessary of there are no binary packages
for your systems, or if you wish to make source level modifications to the
rump kernel components.

Build dependencies
------------------

The following are required for building from source:

- cc (gcc and clang are known to work)
- ld (GNU or Solaris ld required)
- binutils (ar, nm, objcopy)

The short version
-----------------

Clone the repository and run:

- `./buildrump.sh`

You will now find the kernel drivers and necessary headers in `./rump`
ready for use.  Examples on how to use the resulting drivers are available
in the `tests` and `examples` directories.

The long(er) version
--------------------

When run without parameters, `buildrump.sh` implicitly assumes that the
given commands were `checkout fullbuild tests`.  You can override this
default by giving explicit commands.

The `checkout` command will fetch the necessary subset of the NetBSD
source tree from github into `./src` (the location can be changed using
the `-s` parameter).  You are free to use any method for fetching NetBSD
sources, though the only officially supported way is to use the `checkout`
command.  Note that the NetBSD sources and their timestamps may vary from
one buildrump.sh revision to another.  By default, the script checks that
you have the appropriate set of sources even if you do not run `checkout`.

The `fullbuild` command will then instruct the script to to build the
necessary set of tools for building rump kernels, e.g. the BSD version
of `make`, after which it will build the rump kernels.  By default,
`cc` from path is used along with other host tools such as `nm`.
Crosscompilation is documented further below.

If the command `tests` is given, the script will run simple tests
to check that e.g. file systems and the TCP/IP stack work correctly.
If everything was successfully completed, the final output from the
script is "buildrump.sh ran successfully".  Note that `tests` cannot be
run when `buildrump.sh` is used with a crosscompiler or in kernel-only
mode (see below).

To learn more about command line parameters, run the buildrump.sh
script with the `-h` flag.

Crosscompiling
--------------

If the environment variable `$CC` is set, its value is used as the compiler
instead of `cc`.  This allows not only to select between compiling with
gcc or clang, but also allows to specify a crosscompiler.  If `$CC` is set
and does not contain the value `cc`, `gcc`, or `clang` the script assumes
a crosscompiler and will by default use tools with names based on the
target of `$CC` with the format `target-tool` (e.g. `target-nm`).

Crosscompiling for an ARM system might look like this (first command
is purely informational):

	$ arm-linux-gnueabihf-gcc -dumpmachine
	arm-linux-gnueabihf
	$ env CC=arm-linux-gnueabihf-gcc ./buildrump.sh [params]

Since the target is `arm-linux-gnueabihf`, `arm-linux-gnueabihf-nm` etc.
must be found from `$PATH`.  The assumption is that the crosscompiler
can find the target platform headers and libraries which are required
for building the hypercall library.  You can override the defaults
by setting `$AR`, `$NM` and/or `$OBJCOPY` in the environment before
running the script.

Kernel-only mode
----------------

If the `-k` kernel-only parameter is specified, the script will
omit building the POSIX hypercall implementation.  This is useful if
you are developing your own hypercall layer implementation.  See the
[rumpuser-xen](https://github.com/rumpkernel/rumpuser-xen) repository
for the canonical example of using `-k`.

Setting compile flags
---------------------

Normally `buildrump.sh` will do a build with no special compiler flags other than optimisation flags (`-O2`). Mostly this will be fine, but if you are cross compiling or building for a specific architecture variant you can add additional flags using the `-F` option. For example `-F CFLAGS='-march=m32 -mcpu=i586'` will pass those options to the C compiler. As well as `CFLAGS` you can use `AFLAGS` and `LDFLAGS`, `ACFLAGS` to set both `AFLAGS` and `CFLAGS` and `ACLFLAGS` to set all three. You can repeat the `-F` option as many times as necessary. So for example to do a 32 bit build on a 64 bit host use `./buildrump.sh -F ACLFLAGS=-m32`.

Note that not all CPU variants and ABIs are supported by NetBSD and the rump kernel, although a very large number are. The script does not warn about most potential issues.

Debug builds
------------

The default build is a debug build (using `-O2 -g`, and enabling NetBSD assertions). You can increase debugginess with `-D` or more eg `-DDD`. If you want to customize the flags, use eg `-F DBG='-O0 -g'`. Using `-r` will do a release build, without debug symbols or assertions.

Tips for advanced users
=========================

- Place your buildtools in a separate directory, e.g. `$HOME/rumptools`
  using `./buildrump.sh -T $HOME/rumptools fullbuild`.  Put that directory in
  `$PATH`.  You can now do fast build iteration for kernel components by
  going to the appropriate directory and running `rumpmake dependall &&
  rumpmake install`.

- You can list the NetBSD source dates used by `./buildrump.sh checkout`
  by running `./checkout.sh listdates`.

- Assuming you have a commit bit to NetBSD, you can use HEAD from NetBSD
  src and be able to commit your changes to NetBSD from src with the
  following setup:

  - `BUILDRUMP_CVSROOT=dev@cvs.netbsd.org:/cvsroot ./checkout.sh cvs nbcvs HEAD`
  - `./buildrump.sh -s nbcvs fullbuild`

  Of course, replace `dev` with your NetBSD account name.  Equally
  "of course", this operating mode is not officially supported by
  buildrump.sh.  However, if you run into problems that will affect
  buildrump.sh after the checkout date is bumped, report the problems
  using your discretion.
