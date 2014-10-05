The build scripts are all set up for cross compiling, and it should be relatively straightforward.

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

### Linux

If you have a multilib Linux distro things are very easy, you should be able to just use the instructions above without changes.

```
export CC=arm-linux-androideabi-gcc
./buildrump.sh
```

### NetBSD

NetBSD lets you build cross compilers easily using the ``build.sh`` script. Something along these lines should work - you need to build distribution not just tools, and you must set sysroot.

```
./build.sh -U -m sparc64 tools
./build.sh -U -m sparc64 distribution

export PATH=$PWD/obj/tooldir.NetBSD-7.0_BETA-amd64/bin:$PATH
export CC=sparc64--netbsd-gcc
export NM=sparc64--netbsd-nm
export AR=sparc64--netbsd-ar
export OBJCOPY=sparc64--netbsd-objcopy

./buildrump.sh -F CFLAGS=--sysroot=..../src/obj/destdir.sparc64
```