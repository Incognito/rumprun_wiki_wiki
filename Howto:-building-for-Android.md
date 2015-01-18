You need an Android cross compiler from the Android NDK. It has only been tested on a recent version.

To build, set your PATH as appropriate and set the sysroot as required for example:
````
export CC=arm-linux-androideabi-gcc
./buildrump.sh -F CPPFLAGS=--sysroot=/home/justin/android-ndk-r10d/platforms/android-21/arch-arm -F ACLFLAGS=--sysroot=/home/justin/android-ndk-r10d/platforms/android-21/arch-arm
````

If you use the gcc 4.9.1 you may need to set `-F CFLAGS=-Wno-error=maybe-uninitialized`, although this should be fixed.

You can build the tests (they will not run, there is no qemu-user for Android) with

Then you can run the tests on a device or simulator. However there are possibly some toolchain issues still to be resolved.

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
