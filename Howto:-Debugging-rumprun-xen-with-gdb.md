This page is a short tutorial for debugging a rump kernel running on top of Xen and the applications running on top of that.

First, start your domain.  It's usually best to run the domain with `-p` so that you can attach the debugger before any code runs.

```
# xl create -cp domain_config
Parsing config from domain_config
Daemon running with PID 968
```

Then, in another terminal run `utils/dogdb.sh`.  The first parameter is the domain name and the second one is the port the gdb server will listen to.  If none are specified, the defaults `rump-kernel` and `1234` will be used.

```
# sh utils/dogdb.sh
Listening on port 1234
```

Finally, in yet another terminal, run `gdb`, attach to the remote gdb server, set e.g. a breakpoint, and continue execution to hit that breakpoint.

```
$ gdb -q rump-kernel
Reading symbols from /home/pooka/rumprun-xen/rump-kernel...done.
(gdb) target remote:1234
Remote debugging using :1234
0x00000000 in _text ()
(gdb) break ffs_mount
Breakpoint 1 at 0x25150: file /home/pooka/rumprun-xen/rumpsrc/sys/rump/fs/lib/libffs/../../../../ufs/ffs/ffs_vfsops.c, line 348.
(gdb) c
Continuing.

Breakpoint 1, ffs_mount (mp=0x506000, path=0x1c92fc "/etc", data=0x3710a0,
    data_len=0x2ffeb4)
    at /home/pooka/rumprun-xen/rumpsrc/sys/rump/fs/lib/libffs/../../../../ufs/ffs/ffs_vfsops.c:348
348     {
(gdb)
```

Then it's debugging as usual.
