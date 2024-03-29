This page describes [fs-utils](http://repo.rumpkernel.org/fs-utils).

The goal of fs-utils is to provide a set of utilities for accessing and
modifying file system images without having to use host kernel mounts.
To use fs-utils you do not have to be root, you just need read/write
access to the image or device.  The advantage of fs-utils over similar
projects such as mtools is supporting the usage of familiar Unix tools
(`ls`, `cp`, `mv`, etc.) for a large number of file systems.

The project has reached basic stability and are able to modify a number
of different types of file system images on Linux and Solaris-derived
hosts.  Cygwin is also supported, but will not work out-of-the-box due
to disagreements with libtool.

Future work on fs-utils will concentrate on documentation, diagnostic
messages, increasing platform support, testing, and possibly some new
utilities.

The original paper describing fs-utils can be found [here](https://www.netbsd.org/~stacktic/ebc09_fs-utils_paper.pdf)

Supported File Systems
----------------------
- block device based file systems: cd9660, efs, ext2, hfs, ffs, fat, lfs, ntfs, sysvbfs, udf, v7fs
- network based file systems: nfs, smbfs

Utilities
---------

The following operate on a file system image like their standard Unix
counterparts:

- `fsu_cat`, `fsu_chmod`, `fsu_chown`, `fsu_cp`, `fsu_df`, `fsu_diff`, `fsu_du`, `fsu_find`, `fsu_ln`, `fsu_ls`, `fsu_mkdir`, `fsu_mv`, `fsu_rm`, `fsu_rmdir`, `fsu_mknod`, `fsu_mkfifo`, `fsu_chflags`, `fsu_touch`, `fsu_stat`

Since the host kernel does not have knowledge of the image, we supply
additional tools to preserve normal work patterns:

- `fsu_ecp`, `fsu_get`, `fsu_put`: external copy; copy files between the host and image (`fsu_cp` copies within the image).
- `fsu_write`: write stdin to a file within the image.  This can be used where shell output redirection would normally be used.
- `fsu_exec`: execute a program from the image.  This is shorthand for `fsu_ecp` + execute + `rm`.

Usage examples
--------------

The following example demonstrates modifying an initially empty FFS image:

    $ fsu_ls test.ffs -la
    total 4
    drwxrwxr-x  2 0  0  512 Apr  9 12:45 .
    drwxrwxr-x  2 0  0  512 Apr  9 12:45 ..
    $ echo just a demo | fsu_write test.ffs a_file.txt
    $ fsu_ls test.ffs -l
    total 2
    -rw-r--r--  1 0  0  12 Apr  9 12:45 a_file.txt
    $ fsu_ln test.ffs -s a_file.txt a_link.txt
    $ fsu_ls test.ffs -l
    total 2
    -rw-r--r--  1 0  0  12 Apr  9 12:45 a_file.txt
    lrwxr-xr-x  1 0  0  10 Apr  9 12:49 a_link.txt -> a_file.txt
    $ fsu_cat test.ffs a_link.txt
    just a demo
    $ 

The second example is about examining the contents of a downloaded ISO image:

    $ fsu_ls ~/NetBSD-6.1_RC1-amd64.iso -l
    total 12584
    drwxr-xr-x   4 611  0     2048 Feb 19 20:26 amd64
    drwxr-xr-x   2 611  0     6144 Feb 19 20:13 bin
    -r--r--r--   1 611  0    73276 Feb 19 20:29 boot
    -rw-r--r--   1 611  0      555 Feb 19 20:29 boot.cfg
    drwxr-xr-x   2 611  0     2048 Feb 19 20:29 dev
    drwxr-xr-x  26 611  0    12288 Feb 19 20:29 etc
    -r-xr-xr-x   1 611  0     3084 Feb 19 20:29 install.sh
    drwxr-xr-x   2 611  0    10240 Feb 19 20:13 lib
    drwxr-xr-x   3 611  0     2048 Feb 19 19:51 libdata
    drwxr-xr-x   4 611  0     2048 Feb 19 20:29 libexec
    drwxr-xr-x   2 611  0     2048 Feb 19 19:51 mnt
    drwxr-xr-x   2 611  0     2048 Feb 19 20:29 mnt2
    -rw-r--r--   1 611  0  5979454 Feb 19 20:29 netbsd
    drwxr-xr-x   2 611  0    18432 Feb 19 20:13 sbin
    drwxr-xr-x   3 611  0     2048 Feb 19 19:59 stand
    -rwxr-xr-x   1 611  0   195255 Feb 19 20:29 sysinst
    -rwxr-xr-x   1 611  0    32253 Feb 19 20:29 sysinstmsgs.de
    -rwxr-xr-x   1 611  0    31278 Feb 19 20:29 sysinstmsgs.es
    -rwxr-xr-x   1 611  0    32005 Feb 19 20:29 sysinstmsgs.fr
    -rwxr-xr-x   1 611  0    27959 Feb 19 20:29 sysinstmsgs.pl
    drwxr-xr-x   2 611  0     2048 Feb 19 20:29 targetroot
    drwxr-xr-x   2 611  0     2048 Feb 19 19:51 tmp
    drwxr-xr-x   8 611  0     2048 Feb 19 20:29 usr
    drwxr-xr-x   2 611  0     2048 Feb 19 20:29 var
    $ fsu_cat ~/NetBSD-6.1_RC1-amd64.iso /boot.cfg
    banner=Welcome to the NetBSD 6.1_RC1 installation CD
    banner================================================================================
    banner=
    banner=ACPI (Advanced Configuration and Power Interface) should work on all modern
    banner=and legacy hardware.  However if you do encounter a problem while booting,
    banner=try disabling it and report a bug at http://www.NetBSD.org/.
    menu=Install NetBSD:boot netbsd
    menu=Install NetBSD (no ACPI):boot netbsd -2
    menu=Install NetBSD (no ACPI, no SMP):boot netbsd -12
    menu=Drop to boot prompt:prompt
    timeout=30
    $ fsu_du NetBSD-6.1_RC1-amd64.iso -hc amd64 lib
    22M     amd64/binary/kernel
    246M    amd64/binary/sets
    268M    amd64/binary
    14M     amd64/installation/floppy
    1.1M    amd64/installation/miniroot
    54K     amd64/installation/misc
    15M     amd64/installation
    284M    amd64
    4.9M    lib
    289M    total
    $ 

Installation Instructions
=========================
Binary Packages
---------------

If available, installing a binary package is recommended.
for more details, see
https://github.com/rumpkernel/wiki/wiki/Builds:-Binary-packages

Building from Source
--------------------

When building from source, you must first ensure the prerequisites are
available.  fs-utils uses file system drivers provided by rump kernels.
Build and install them in the following manner:

- Clone the buildrump.sh repository (http://repo.rumpkernel.org/buildrump.sh)
- Build and install: `./buildrump.sh -d destbase checkout fullbuild`

The destbase directory can be e.g. `/usr/local`.

Then, in the fs-utils directory:

* `./configure`
* `make`

Note: if you installed rump kernel components to a non-standard directory,
in the normal autoconf fashion you need to set `CPPFLAGS` and `LDFLAGS`
before running configure.