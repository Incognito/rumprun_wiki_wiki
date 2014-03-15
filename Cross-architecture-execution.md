Rump kernels can easily be cross compiled for a different architecture, just adjust `CC` to the appropriate compiler.

You can also however execute the resulting kernels on a non-native architecture using `qemu`. This is useful for testing purposes, either if you do not have access to a machine with the architecture you want to test, or if it is less convenient, for example if it is slow.

While it is possible to run dynamically linked executables with qemu, it is a bit fiddly as you need to tell it where to find the libraries. Therefore it is much easier to use statically linked executables.

The `qemu-user` setup for executing cross architecture executables is available on Linux, and is a work in progress for [FreeBSD](https://wiki.freebsd.org/QemuUserModeHowTo). It is not yet available on NetBSD (that would be a fun project). The instructions below are for Linux.

Unfortunately `glibc` does not do static linking very well, so I have used [Musl libc](http://www.musl-libc.org/) which is well suited for static linking. This means you need a Musl cross toolchain. I used [Musl-cross](https://bitbucket.org/GregorR/musl-cross). It needs to be a gcc toolchain as clang is not yet supported on most of the NetBSD architectures. There are [binary downloads of Musl-cross](https://googledrive.com/host/0BwnS5DMB0YQ6bDhPZkpOYVFhbk0/musl-0.9.15/) available

Note that for the next few days you need to use a NetBSD head tree with `buildrump.sh` but as this will shortly be fixed I will not give the instructions for this.

Install `qemu-user`. This should be packaged up for your Linux distro, eg for Ubuntu or Debian you need to do `apt-get install qemu binfmt-support qemu-user-static`.

Add the path to your cross compiler (which should be under /opt/cross/musl/ for the precompiled binaries) to your path and do the following:
````
export CC=powerpc-linux-musl-gcc # or whichever architecture you want
export LDFLAGS=-static
./buildrump.sh -V mkpic=no fullbuild tests
````

All the tests should run fine, and if you check the executables and libraries built should all be cross compiled.

TODO explain how to use gdb on a non native executable.

Known working architectures:
* powerpc

Architectures with issues:
* arm is hanging in the networking test TODO debug
* mips, mipsel are hanging on VFS test with actual file system
