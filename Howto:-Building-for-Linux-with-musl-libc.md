The [musl libc](http://www.musl-libc.org/) is an alternative libc for Linux.  Some Linux distros, such as Sabotage, use it as a full-out replacement for glibc.  On systems which use glibc by default, it is possible to "pseudo-crosscompile" binaries to use musl by using the `musl-gcc` wrapper.

buildrump.sh requires at least musl _after_ 0.9.12 (which as of writing this hasn't been released).  With a sufficiently new musl, native musl distros are expected to just work.  The rest of this page documents using musl-gcc.

Set the following environment variables:

```
CC=musl-gcc
AR=ar
NM=nm
OBJCOPY=objcopy
```

Then run buildrump.sh.  That's it.  Note that virtif will not be built unless your musl environment offers the Linux kernel headers.