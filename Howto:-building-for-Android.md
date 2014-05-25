You need an Android cross compiler. You can install the Android NDK, but it is easier to use the version that your Linux distro provides if possible. For example for Debian and Ubuntu the package you need is ```gcc-arm-linux-androideabi``` for ARM Android or ```gcc-i686-linux-android``` for x86. There are no Android MIPS cross compilers packaged though. This will provide ```arm-linux-gnueabi-*``` tools, all set up to use the Android headers.

You may or may not need to use ```BUILDRUMP_LDFLAGS="-fuse-ld=bfd"```; if ```arm-linux-androideabi-gcc -Wl,--version``` says the linker is GNU gold then you will as the ```gold``` linker does not build correctly.

To build, set
````
export CC=arm-linux-androideabi-gcc
export BUILDRUMP_LDFLAGS="-fuse-ld=bfd"
./buildrump.sh -V MKPIC=no fullbuild
````

You can build the tests (they will not run, there is no qemu-user for Android) with

````
export LDFLAGS="-fuse-ld=bfd"
./buildrump.sh tests
```

Then you can run the tests on a device or simulator

````
adb -d push obj/brtests/fstest/fstest /data/local/tmp
adb -d shell /data/local/tmp/fstest

Reading version info from /kern:

NetBSD 6.99.39 (RUMP-ROAST) #0: Wed Apr  2 18:21:45 BST 2014
	justin@brill:/home/justin/rump/buildrump-android/obj/lib/librump
rump kernel halting...
syncing disks... done
unmounting file systems...
unmounting done
halted
````

Testing is not yet very extensive, so please report any issues. Currently there is a build server at http://builds.rumpkernel.org/, not running tests.
