This page details how to configure a Soft RAID or encrypted block device with the `raidctl` and `cgdconfig` tools provided by [rumprun-posix](http://repo.rumpkernel.org/rumprun-posix), respectively.

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

Now, we are ready to run the standard raidctl initialization procedure. Assuming you are in the rumprun-posix directory, adjust the paths as necessary otehrwise:

```
$ ./bin/raidctl -C /raid.conf raid0
$ ./bin/raidctl -I 24816 raid0
```

Then we can e.g. create a file system:

```
$ ./bin/newfs raid0a
/dev/rraid0a: 31.9MB (65408 sectors) block size 8192, fragment size 1024
	using 4 cylinder groups of 7.98MB, 1022 blks, 1984 inodes.
super-block backups (for fsck_ffs -b #) at:
32, 16384, 32736, 49088,
```

We also observe that the file system has the expected (2x16MB) size.  Other `raidctl` commands can be executed in a similar fashion.

## CryptoGraphic Disk (cgd)

The _cgd_ driver provides encrypted access to block devices.  The block device that encrypts communication with its backend is configured using the `cgdconfig` utility, and again everything we do in this tutorial is detailed to exhaustion in the [manual page](http://man.NetBSD.org/cgi-bin/man-cgi?cgdconfig++NetBSD-current).

Run a rump server with cgd support:

```
$ rump_server -lrumpdev -lrumpdev_disk -lrumpvfs  -lrumpdev_cgd -lrumpkern_crypto -lrumpdev_rnd -d key=/disk1,hostpath=/tmp/d1,size=16777216 unix:///tmp/cgd
```

Use `cgdconfig` to create a configuration file. Notably, we used a static, stored key configuration file instead of a passphrase generated keyfile. The reason for this is quite simple: a rump kernel does not (yet) have console input, so reading the passphrase using rumprun-posix is not possible.

```
$ ./bin/cgdconfig -g -o /cgd.conf -k storedkey aes-cbc 192
$ ./bin/cat /cgd.conf
algorithm aes-cbc;
iv-method encblkno1;
keylength 192;
verify_method none;
keygen storedkey key AAAAwLCirNKBT1a12+plWIS1BCP2gb \
                     2xquBNXw==;
```

Configure the cgd device and create a file system on it:

```
$ ./bin/cgdconfig cgd0 /disk1 /cgd.conf
$ ./bin/newfs cgd0a
/dev/rcgd0a: 16.0MB (32768 sectors) block size 4096, fragment size 512
    using 4 cylinder groups of 4.00MB, 1024 blks, 1920 inodes.
super-block backups (for fsck_ffs -b #) at:
32, 8224, 16416, 24608,
```

Now, `/dev/cgd0a` can be mounted inside the rump kernel like any other block device. To offer final proof that the disk backend is encrypted, we check that the backing file looks nothing like a normal disk with a disklabel (further analysis is left as an exercise for the reader).

```
$ hexdump -C /tmp/d1 | sed 10q
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00002000  54 e5 0c 8d 78 fc 34 fe  f0 e8 75 b7 67 72 9d 0d  |T...x.4...u.gr..|
00002010  69 37 8c 66 9d 46 28 95  15 03 91 1c e8 8f 5d a9  |i7.f.F(.......].|
00002020  9e a7 ca 44 85 ac 4f 6a  3f 81 a6 de fd a5 09 80  |...D..Oj?.......|
00002030  d4 b0 92 0a 9d bd 60 da  9f 5e c0 3d 79 c6 f5 df  |......`..^.=y...|
00002040  e4 c9 f9 6b 15 f1 b5 02  4d c7 51 1d 9f d1 6d 8b  |...k....M.Q...m.|
00002050  48 33 be 6f 00 d7 b0 64  22 17 d4 6b 38 d4 01 51  |H3.o...d"..k8..Q|
00002060  a3 ad ad c1 b6 3a 37 7f  da c5 65 8d a3 5f 02 2e  |.....:7...e.._..|
00002070  e4 12 3e b7 43 cf 73 c3  e8 3a b0 e6 24 be 93 f0  |..>.C.s..:..$...|
```
