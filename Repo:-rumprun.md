This page describes [rumprun](http://repo.rumpkernel.org/rumprun).

Rumprun is a wrapper for running programs that were written for a normal POSIX (NetBSD) system to run them under a rump kernel.  Rumprun is especially useful for running NetBSD configuration tools on non-NetBSD systems for the purposes of configuring rump kernels.

Rumprun takes NetBSD program (see Makefile) and compiles it using the NetBSD ABI.  The system calls that the program makes are being served by a rump kernel instead of the host kernel.

Currently tested on Linux and NetBSD, and should be generally
portable. A good deal of NetBSD utilities will already work
(see end of this file for list of ones built out-of-the-box).
Currently only known to work on i386 and amd64 architectures,
but others are being worked on as they need small fixes.

Building
========

To build, run: 
````
./buildnb.sh
```

This will automatically fetch and build all dependencies, so assuming you
have build tools (compiler etc.) installed, you are good to go.

Running
=======

There are two possibilities for operation mode: remote clients and local clients.  Both are
described below.  If you are unsure which mode is relevant for you, you most likely
want remote clients.

Remote clients
--------------

When using remote clients, you run the rump kernel runs in a separate process
from the applications and communicates using IPC.  The operation mode resembles
a typical OS setup, where the kernel is disjoint from the applications running
on it.

The most straightforward way to do this is in conjunction
with the readily available `rump_server` program.  A brief
example follows.

First, we run the server, for example with IP networking components:

````
$ ./rumpdyn/bin/rump_server -lrumpnet -lrumpnet_net -lrumpnet_netinet -lrumpnet_netinet6 -lrumpnet_shmif unix://csock
$
````

Now we can make system calls to `rump_server` via the local domain
socket (`unix://csock`).  We control the location that programs
access by setting the env variable `$RUMP_SERVER`.

To configure one shmif interface:

```
$ . rumpremote.sh
rumpremote (NULL)$ export RUMP_SERVER=unix://csock
rumpremote (unix://csock)$ ifconfig shmif0 create
rumpremote (unix://csock)$ ifconfig shmif0 linkstr busmem
rumpremote (unix://csock)$ ifconfig shmif0 inet 1.2.3.4 netmask 0xffffff00
rumpremote (unix://csock)$ ifconfig shmif0
shmif0: flags=8043<UP,BROADCAST,RUNNING,MULTICAST> mtu 1500
	address: b2:a0:57:b0:8a:69
	linkstr: busmem
	inet6 fe80::b0a0:57ff:feb0:8a69%shmif0 prefixlen 64 scopeid 0x2
	inet 1.2.3.4 netmask 0xffffff00 broadcast 1.2.3.255
```

The interface will persist until `rump_server` is killed or halted,
like in a regular system an interface will persist until the
system is rebooted.  The exception is, of course, if you remove the interface
before reboot with `ifconfig shmif0 destroy`.

Using local clients
-------------------

As opposed to remote clients, with local clients both the rump kernel and client(s) exist in the
same host process.

This mode is under development and there will be examples shortly. The build process is
similar but you link in the rump kernel instead of just the rumpclient library.


Bundled programs
================

Binaries that are bundled with the default rumprun installation are
listed here.  Generally speaking, supporting a
program is a matter of pulling in the unmodified NetBSD source code and
adding the name of the program to `Makefile`, so if you have requests,
do not hesitate to file an issue.  The manual page for each command
is available from http://man.NetBSD.org/,
e.g. [`cat`](http://man.NetBSD.org/cgi-bin/man-cgi?cat++NetBSD-current).

* ```arp```
* ```cat```
* ```cgdconfig```
* ```cp```
* ```dd```
* ```disklabel```
* ```df```
* ```dump```
* ```dumpfs```
* ```fsck```
* ```fsck_ext2fs```
* ```fsck_ffs```
* ```fsck_lfs```
* ```fsck_msdos```
* ```fsck_v7fs```
* ```ifconfig```
* ```ktrace``` there is no kdump support yet. you can cat `ktrace.out` to host
* ```ln```
* ```ls```
* ```makefs```
* ```mkdir```
* ```mknod```
* ```modstat```
* ```mount``` mount -vv needs some more work (it fork+exec's)
* ```mount_ffs```
* ```mv```
* ```ndp```
* ```newfs```
* ```newfs_ext2fs```
* ```newfs_lfs```
* ```newfs_msdos```
* ```newfs_sysvbfs```
* ```newfs_udf```
* ```newfs_v7fs```
* ```npfctl```
* ```pax```
* ```pcictl```
* ```ping```
* ```ping6``` uses signals not timeouts so only first ping working
* ```raidctl```
* ```reboot``` not working due to signals; there is a simple ```halt``` available.
* ```rm```
* ```rmdir```
* ```rndctl```
* ```route```
* ```sysctl```
* ```umount```
* ```vnconfig``` the vnd kernel driver is not provided by rumprun ;)
* ```wlanctl```
* ```wpa_passphrase``` does not really use the rump kernel, for completeness with `wpa_supplicant`
* ```wpa_supplicant```

For programs that fork and exec, the rumpclient library will fork the provided host binary, so for ktrace you must do ```./bin/ktrace ./bin/ls```.

FAQ
===

- Why does shell redirecting not work?  E.g. `wpa_passphrase net passkey > wpa.conf` creates the config file on the host instead of in the rump kernel.
    - Your shell is not a rumprun program, so shell redirects are interpreted in host context.  As a workaround, use `dd`, which is a rumprun program, e.g. `wpa_passphrase net passkey | dd of=wpa.conf`
