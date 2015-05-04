This page describes [rumpctrl](http://repo.rumpkernel.org/rumpctrl).

Rumpctrl provides configuration, control and diagnostic utilities for
rump kernels.  These utilities can be run on a POSIX-type userspace
platform to remotely inspect and adjust the status of rump kernels via
the _sysproxy_ remote system call facility.  This repository provides
both the build framework and a selection of familiar utilities such as
`ifconfig`, `mount`, `sysctl`, and more.


Building
========

To build, run: 
````
./buildnb.sh
```

This will automatically fetch and build all dependencies.

<!--
XXX: "nobuildrump" mode doesn't work currently

If you already have a rump kernel install you need to make sure rumpctrl can find the libraries (and for the tests, the `rump_server` binary, so you may need to set `LIBRARY_PATH` and `LD_LIBRARY_PATH`, and run:
````
./buildnb.sh nobuildrump
```
-->

If you want support for the experimental ZFS utilities to be included, run:

```
./buildnb.sh zfs
```

Running
=======

The model of operation is such that the rump kernel runs in a separate
domain from the control applications.  The rumpctrl utilities run as
userspace processes, and the rump kernel can be for example a userspace
rump kernel server, or a rumprun unikernel running on Xen.

The environment variable `$RUMP_SERVER` determines which method and
address the rumpctrl utility uses for communicating with the rump kernel.
Currently, two methods are supported (as of writing this more
are being planned):

* `unix`: local domain sockets
* `tcp`: TCP communication

The address is given in an URL-like fashion, e.g. `unix:///path/to/socket`
or `tcp://1.2.3.4:12345`.

For example, assuming a rump kernel server accepting sysproxy requests
via a unix domain socket located at path `csock`, we can create and
configure a networking interface in the following fashion:

```
$ . rumpctrl.sh
rumpctrl (NULL)$ export RUMP_SERVER=unix://csock
rumpctrl (unix://csock)$ ifconfig shmif0 create
rumpctrl (unix://csock)$ ifconfig shmif0 linkstr busmem
rumpctrl (unix://csock)$ ifconfig shmif0 inet 1.2.3.4 netmask 0xffffff00
rumpctrl (unix://csock)$ ifconfig shmif0
shmif0: flags=8043<UP,BROADCAST,RUNNING,MULTICAST> mtu 1500
	address: b2:a0:57:b0:8a:69
	linkstr: busmem
	inet6 fe80::b0a0:57ff:feb0:8a69%shmif0 prefixlen 64 scopeid 0x2
	inet 1.2.3.4 netmask 0xffffff00 broadcast 1.2.3.255
```


Bundled programs
================

A few dozen NetBSD utilities such as `ifconfig`, `sysctl`, `dd` and
`wpa_supplicant` are bundled with rumpctrl.  You can list the currently
available ones by running `rumpctrl_listcmds` (the routine is provided
by `rumpctrl.sh`).

Generally speaking, supporting a program is a matter of pulling in the
unmodified NetBSD source code and adding the name of the program to
`Makefile`, so if you have requests, do not hesitate to file an issue.

The manual page for each command
is available from http://man.NetBSD.org/,
e.g. [`cat`](http://man.NetBSD.org/cgi-bin/man-cgi?cat++NetBSD-current).

Caveats
-------

* ```ktrace```: there is no kdump support yet. you can cat `ktrace.out` to a NetBSD host and kdump there
* ```mount```: mount -vv needs some more work (it fork+exec's)
* ```ping6```: uses signals not timeouts so only first ping working
* ```reboot```: not working due to signals; there is a simple ```halt``` available.
* ```wpa_passphrase```: does not really use the rump kernel, for completeness with `wpa_supplicant`

For programs that fork and exec, the rumpclient library will fork the provided host binary, so for ktrace you must do ```./bin/ktrace ./bin/ls```.

FAQ
===

- Why does shell redirecting not work?  E.g. `wpa_passphrase net passkey > wpa.conf` creates the config file on the host instead of in the rump kernel.
    - Your shell is not a rumpctrl program, so shell redirects are interpreted in host context.  As a workaround, use `dd`, which is a rumprun program, e.g. `wpa_passphrase net passkey | dd of=wpa.conf`
