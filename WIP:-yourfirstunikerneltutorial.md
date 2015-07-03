The [[rumprun unikernel|Repo:-Rumprun]] enables running POSIX applications
as unikernels on top of embedded systems and cloud hypervisors such as
Xen and KVM.  This tutorial will go over the very basics of building and
launching rumprun unikernels.  Even though the main purpose of rumprun
is to support existing, unmodified applications, we will used a "hello
world" class hand-crafted application here.  The skills you learn will
be applicable to building real-world programs as rumprun unikernels.
We will use commands which produce binaries for QEMU/KVM, but will out the
necessary replacements if you want to follow the tutorial on Xen instead.



Getting Started
===============

The first thing to note is that rumprun unikernels are always
cross-compiled.  In practice, it means that the compiler will never
run on the rumprun unikernel.  In case a software package supports
cross-compiling, odds are that you can just compile it.

Before we get to building application software, we need to build the
rumprun framework itself.  The first thing to know is that we do not ship
our own compiler.  Instead, we try to make use of whatever compiler you
specify.  The specified compiler determines the machine architecture
which the produced rumprun unikernels are capable of running on.
By default, you host compiler will be used, so if you are on x86 and
want the unikernel to run on x86, you don't need to specify anything.

The second thing to know is that you specify the platform you want the
unikernels to run on at this stage.  As a rule of thumb, use `xen` if
you want to run on Xen, and `hw` if you want to run on anything else,
including bare metal and KVM.

Putting those two bits of information together, let's run the rumprun
framework build script.  We specify `CC` explicitly just to show how it
can be set.  NOTE: if you are on OS X, you need to obtain an ELF cross
compiler which you specify to the process.  The host compiler is not
usable because it generates the wrong object format (Mach-O instead
of ELF).

```
$ git clone http://repo.rumpkernel.org/rumprun
$ cd rumprun
$ git submodule update --init
$ CC=cc ./build-rr.sh hw
[...]
>> Built rumprun for hw : x86_64-rumprun-netbsd
>> cc: x86_64-rumprun-netbsd-gcc
>>
>> ./build-rr.sh ran successfully
```

Make note of the toolchain tuple (`x86_64-rumprun-netbsd`) and compiler
(`x86_64-rumprun-netbsd-gcc`) names.  They may be different on your
system.  Before we proceed to the next stage, let's put the toolchain
into our path:

```
$ export PATH="${PATH}:$(pwd)/app-tools"
```


Building applications
=====================

So we have the platform built.  How does that translate into a running
program?  Usually, you have to build and link the application.  That's
precisely what you need to do here too.  Let's go into a test directory
and try to cross-compile a simple application as a rumprun unikernel.

```
$ mkdir -p test
$ cd test
$ cat > helloer.c << EOF
#include <stdio.h>
#include <unistd.h>
int
main()
{

	printf("Hello, rumprun ... I'm feeling tired\n");
	sleep(2);
	printf("much better!\n");
	return 0;
}
EOF
```

You'll notice that the programming environment looks like like a normal
C/POSIX environment.  That compatibility is a given, otherwise existing
software would not run.  So, let's try to run the above code _on the
host_.  Checking that stuff runs on the host is not required when
building rumprun unikernel -- sometimes the host may not even support
the same features as rumprun -- but it's nevertheless a good way to get
an idea of what should happen.  Therefore, we use it as an educational
tool.

```
$ cc -o helloer helloer.c
$ ./helloer
Hello, rumprun ... I'm feeling tired
much better!
$
```

Ok, seemed to work.  Let's try the same for rumprun.  We need to use the
cross-compiler wrapper produced by the `build-rr.sh` script.  Good for us,
we remembered to make note of the wrapper name.  Use whatever build-rr
printed for you.

```
$ x86_64-rumprun-netbsd-gcc -o helloer-rumprun helloer.c
```

So, um, how do we run that?  The tool for running rumprun unikernels
is eponymously called `rumprun`.  Let's try that the simple way:

```
$ rumprun qemu helloer-rumprun

!!!
!!! NOTE: rumprun is experimental. syntax may change in the future
!!!

rumprun: error: helloer-rumprun: not a rumprun unikernel (did you forget rumpbake?)
```

Ignoring the rather verbose warning about the syntax of the tool,
we observe that no, we cannot run it.  But we got a clue:
we need to _rumpbake_ the binary.

(the remainder of this tutorial will omit the verbose "X is experimental
and may change" warnings from the quoted output)


Baking
------

Normally you just compile and are good to go.  What gives with this
baking step?  Consider the regular operating system case.  Your kernel
is implicitly present on the system where you run the application.
With rumprun there is no implicit kernel since everything is a single
package running on top of a hypervisor or bare metal.  Therefore, we
must explicitly specify the bits which would normally be specified by
booting a system with a given kernel.  This specifying is done using
the `rumpbake` command.  There are a number of reasons why `rumpbake`
is a separate command instead of being part of the compiler, but those
reasons are beyond the scope of this tutorial.

To use rumpbake, we need to specify the kernel bits we want, the output
binary and the input binary.  The kernel bits are a set of rump kernel
components, and the "correct" set depends on what precisely you want to
do with your application.  For example, if you're running a web server,
you most likely do not need audio drivers.  If you don't want to think
too hard, there is a "generic" configuration which includes more or less
everything.  We'll simply use that:

```
$ rumpbake hw_generic helloer-rumprun.bin helloer-rumprun
```

That's it.  We can now run the binary.


Running applications
====================

As mentioned earlier, we provide the `rumprun` tool for running rumprun
unikernels.  Let's try the same snippet as earlier, which one exception:
we use the `-i` option to specify that we want an interactive session
(otherwise we couldn't see our printf output):

```
$ rumprun qemu -i helloer-rumprun.bin 
```

You should see the results.  Press ctrl-C to exit QEMU.  If you system
supports KVM (kernel virtual machine), you can use `kvm` instead of
`qemu` on the above command line.

The rumprun tool provides a large number of options.  Going over them
is beyond the scope of this tutorial, but please try `rumprun -h` to
see the usage.


More realistic builds
=====================

Of course, you will not be manually building large projects manually with
`cc`.  For the remainder of this tutorial, we'll add GNU autotools support
to our example program and show how to build it.  This section assumes
you have the relevant GNU autotools installed of your host (autoconf,
automake, etc.)

Other cross-compile compatible build frameworks will work roughly the
same way, usually by setting the toolchain in the environment.  However,
covering those is out of the scope of this tutorial.

```
$ cat > configure.ac << EOF
AC_PREREQ([2.66])
AC_INIT([1], [2], [3])

AC_CONFIG_SRCDIR([helloer.c])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_AUX_DIR([build-aux])

AC_CANONICAL_TARGET

AM_INIT_AUTOMAKE([1.11 foreign subdir-objects -Wall -Werror])
AM_MAINTAINER_MODE

AC_PROG_CC
AC_PROG_CC_C_O

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
EOF
$ cat > Makefile.am << EOF
bin_PROGRAMS= helloer
helloer_SOURCES= helloer.c
EOF
$ autoreconf -i
```

Ok, we should have a simple GNU autotools skeleton in place.  Let's
test it on the host again.

```
$ ./configure
[...]
$ make
[...]
$ ./helloer
[...]
```

Seems to work.  Let's clean the result, and cross-compile it for rumprun.
Assuming your tools are in the path, the only thing that you need to
specify to a GNU configure script is the correct `--host` parameter,
and everything else will work like magic.  The correct value, as you
remember, was printed by `build-rr`:

```
$ make distclean
[...]
$ ./configure --host=x86_64-rumprun-netbsd
[...]
$ make
```

Now all that is left is baking and running:

```
$ rumpbake hw_generic helloer-autoconf.bin helloer
$ rumprun qemu -i helloer-autoconf.bin
```

Homework
========

Please try the above techniques for building some of your favorite
software as rumprun unikernels, and report success to failure
to the [[rumpkernel community|Info:-Community]].
