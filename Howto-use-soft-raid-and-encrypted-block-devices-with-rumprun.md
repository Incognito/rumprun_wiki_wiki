This page details how to configure a Soft RAID or encrypted block device with the `raidctl` and `cgdconfig` tools provided by [rumprun](https://github.com/rumpkernel/rumprun), respectively.  We use `rumpremote` in this tutorial, though similar results could be reached by using the Lua console for rumprun.

## RAIDframe

The NetBSD software RAID framework is called _RAIDframe_.  The procedure for using RAIDframe in a rump kernel is more or less similar to using it on a normal NetBSD system and can be found in [raidctl manual page](http://man.NetBSD.org/cgi-bin/man-cgi?raidctl++NetBSD-current).  In this tutorial we will configure a simple RAID0 constructed of those virtual block devices backed by host files.

First, we create a configuration file which specifies our RAID.  We will no go into detail on the format; refer to the manual page.

```
$ cat > /tmp/raid.conf
START array
1 2 0

START disks
/disk1
/disk2

START layout
32 1 1 0

START queue
fifo 100
```

Then, we run rump_server with two 16MB devices backed by host files:

```
$ rump_server -lrumpdev -lrumpdev_disk -lrumpvfs  -lrumpdev_raidframe -d key=/disk1,hostpath=/tmp/d1,size=16777216 -d key=/disk2,hostpath=/tmp/d2,size=16777216 -d key=/raid.conf,hostpath=/tmp/raid.conf,size=host,type=reg unix:///tmp/raidframe
```

Note that since `/tmp/raid.conf` is a host file, we need to expose it to the rump kernel.  It is also possible to create the configuration file inside the rump kernel, but we will not go into details or tradeoffs of that.

Now, we are ready to run the standard raidctl initialization procedure:

```
$ ./rumpremote raidctl -C /raid.conf raid0
$ ./rumpremote raidctl -I 24816 raid0
```

Then we can e.g. create a file system:

```
$ ./rumpremote newfs raid0a
/dev/rraid0a: 31.9MB (65408 sectors) block size 8192, fragment size 1024
	using 4 cylinder groups of 7.98MB, 1022 blks, 1984 inodes.
super-block backups (for fsck_ffs -b #) at:
32, 16384, 32736, 49088,
```

We also observe that the file system has the expected (2x16MB) size.  Other `raidctl` commands can be executed in a similar fashion.

## CryptoGraphic Disk (cgd)

The _cgd_ driver provides encrypted access to block devices.  The block device that encrypts communication with its backend is configured using the `cgdconfig` utility, and again everything we do in this tutorial is detailed to exhaustion in the [manual page](http://man.NetBSD.org/cgi-bin/man-cgi?cgdconfig++NetBSD-current).

[the rest is still TODO]