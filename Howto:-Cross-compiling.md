The build scripts are all set up for cross compiling, and it should be relatively straightforward.

==Linux==

If you have a multilib Linux distro things are very easy, you should be able to just do

```
export CC=arm-linux-androideabi-gcc
./buildrump.sh
```

==NetBSD==

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