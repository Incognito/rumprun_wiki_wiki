In this tutorial we cover the basic steps for using rump kernels as
a kernel development and debugging facility, all in the comform of
userspace using standard userspace tools.  As a use case, will study
examining file system operations, modifying a file system driver and
seeing what happens if we introduce a kernel panic.

You will need a debugger (`gdb`) and a working C compiler.  We will
install rump kernels and other tools as part of the tutorial.  You will
also need a shell account on a machine with a network connection.
The tutorial has been tested on x86_64 Ubuntu 13.10 Linux.

Throughout the tutorial, we will be using three separate terminals.
For clarity, we will state which terminal to run the commands in.
As you gain experitise, you will not necessarily need three terminals
for the same tasks, but here we do it for simplicity.

We assume that you run all commands in the tutorial from a single
directory.  The commands are self-contained, so if you are not interested
in reading the full tutorial text, you can just run the commands.


Installing prerequisites
------------------------

For this tutorial, we will need _rumprun-posix_.  If you
already have it built, you may skip this step.

1. Run (terminal 1):

```
$ git clone http://repo.rumpkernel.org/rumprun-posix rr
$ cd rr
$ ./buildnb.sh
$ make
$ cd buildrump.sh
$ ./buildrump.sh -T rumptools -q
$ cd ../../
```


Assuming you did not get any errors, you now have all of the necessary
tools.


Running a rump kernel
---------------------

First, we need to bootstrap the rump kernel and access the file system
driver.  There are many way to do this, but the easiest way is to run
`rump_server` and use rumprun-posix commands for driving the server.  This is
also the route that we will take.

We need a configuration which supports the tmpfs file system driver we
want to toy with.  There are two ways to do this.  The first, and easier
one, is to run `rump_allserver` which includes all driver components
that were available when the rump_allserver binary was built.  The second
and more advanced approach is to specify the list of component manually.
Since manually specifying components gives a better educational value,
we will use that approach.

We know that the tmpfs driver is provided by the rumpfs_tmpfs component.
To figure out its dependencies, we can use the `rump_wmd` command
(mnemonic: wmd = where's my dependency).

In terminal 1:
```
$ rr/buildrump.sh/rump/bin/rump_wmd -Lrr/buildrump.sh/rump/lib -lrumpfs_tmpfs
DEBUG0: Searching component combinations. This may take a while ...
DEBUG0: Found a set
-lrumpvfs -lrumpfs_tmpfs
```

So, for tmpfs we just need tmpfs itself and rumpvfs.

To start a rump server which serves the tmpfs file system, in terminal 1:
```
$ rr/rumpdyn/bin/rump_server -lrumpfs_tmpfs -lrumpfs_tmpfs -lrumpvfs -s unix://ctrl
```

Note that the server stays in the foreground.  This is because we
gave the `-s` parameter, which is generally useful for easy control.
Press ctrl-c and re-run the command to get the idea.

The last parameter is an URL where the server listens to for commands.
We gave a relative pathname to a unix socket.  If you do a directory
listing in the current directory while the server is running, you will
see a file system socket `ctrl`.

Now, we will use rumprun-posix in terminal 2:
```
$ . rr/rumpremote.sh
rumpremote (NULL)$ export RUMP_SERVER=unix://ctrl
rumpremote (unix://ctrl)$ sysctl vfs.generic.fstypes
vfs.generic.fstypes = rumpfs tmpfs
```

So now we know that have a setup in terminal 2 which can access the
kernel server, and we also know that the kernel server provides tmpfs.

Let's try some debugging action.  We could attach gdb to the already
running rump_server, but here we'll just run rump_server under gdb.
So, in terminal 1, press ctrl-c and then run:

```
$ gdb rr/buildrump.sh/rump/bin/rump_server 
[...]
(gdb) run -lrumpfs_tmpfs -lrumpvfs -s unix://ctrl
Starting program: /home/pooka/tmp/demo/rr/buildrump.sh/rump/bin/rump_server -lrumpfs_tmpfs -lrumpvfs -s unix://ctrl
[...]
```

Let's say we're interested in seeing what happens when tmpfs creates
a directory.  We'll put a breakpoint in `tmpfs_mkdir` by first pressing
ctrl-c in terminal 1, and then running

```
(gdb) break tmpfs_mkdir
Breakpoint 1 at 0x7ffff6bcae60: file /home/pooka/tmp/demo/rr/buildrump.sh/src/sys/rump/fs/lib/libtmpfs/../../../../fs/tmpfs/tmpfs_vnops.c, line 808.
(gdb) c
Continuing.
```

Then, we need to trigger a tmpfs directory creation by first mounting
tmpfs and creating a directory inside it.  So in terminal 2 (and note,
we do not have to resetup terminal 2 despite restarting rump_server
since the new rump_server uses the same URL):

```
rumpremote (unix://ctrl)$ mkdir /mnt
rumpremote (unix://ctrl)$ mount_tmpfs swap /mnt
rumpremote (unix://ctrl)$ mount
rumpfs on / type rumpfs (local)
tmpfs on /mnt type tmpfs (local)
rumpremote (unix://ctrl)$ mkdir /mnt/test
```

Note that the last command does not return, and looking into terminal 1,
we see that we have hit the breakpoint:

```
[Switching to Thread 0x7fffeebb3700 (LWP 6832)]

Breakpoint 1, tmpfs_mkdir (v=0x7fffeebb2c10)
    at /home/pooka/tmp/demo/rr/buildrump.sh/src/sys/rump/fs/lib/libtmpfs/../../../../fs/tmpfs/tmpfs_vnops.c:808
808	{
(gdb) 
```

Standard gdb commands are available, and you can for example list
the stack trace (`bt`), print values (`p` and `x`) or single step the
execution (`n`) and `s`).  This is not a tutorial on gdb, but for
reference, let's do one thing:

```
(gdb) up
#1  0x00007ffff7aa2b11 in VOP_MKDIR (dvp=0x6d86f0, vpp=0x7fffeebb2ca8, 
    cnp=<optimised out>, vap=<optimised out>)
    at /home/pooka/tmp/demo/rr/buildrump.sh/src/lib/librump/../../sys/rump/../kern/vnode_if.c:835
835		error = (VCALL(dvp, VOFFSET(vop_mkdir), &a));
(gdb) 
#2  0x00007ffff6e0b959 in do_sys_mkdirat (l=<optimised out>, fdat=-100, 
    path=<optimised out>, mode=493, seg=UIO_USERSPACE)
    at /home/pooka/tmp/demo/rr/buildrump.sh/src/lib/librumpvfs/../../sys/rump/../kern/vfs_syscalls.c:4576
4576		error = VOP_MKDIR(nd.ni_dvp, &nd.ni_vp, &nd.ni_cnd, &vattr);
(gdb) p nd
$14 = {ni_atdir = 0x0, ni_pathbuf = 0x6da000, ni_pnbuf = 0x6dcc00 "/mnt/test", 
  ni_rootdir = 0x6d8de0, ni_erootdir = 0x0, ni_vp = 0x0, ni_dvp = 0x6d86f0, 
  ni_pathlen = 1, ni_next = 0x6dcc09 "", ni_loopcnt = 0, ni_cnd = {
    cn_nameiop = 1, cn_flags = 2146328, cn_cred = 0x66df00, 
    cn_nameptr = 0x6dcc05 "test", cn_namelen = 4, cn_consume = 0}}
```

If you want, spend some time playing around in gdb before continuing.
For example, figure out the syscall entrypoint from the stack trace, but
a breakpoint there, run another mkdir command, and single-step through
the whole execution.  For fun, try to see where the EEXIST error comes
from if you try to create the directory to a filename that already exists.

(gdb tip: press `ctrl-x a` for a nicer user interface)


Modifying the kernel driver
---------------------------

Above we examined the driver.  Let's make some changes to it and
see how it runs.  Let's make tmpfs_mkdir print the PID of everyone who
creates a directory.  To do that, we will need to change the driver
source and recompile the driver.

In terminal 3, run:

```
$ cd rr/buildrump.sh/src/sys/rump/fs/lib/libtmpfs
$ $EDITOR ../../../../fs/tmpfs/tmpfs_vnops.c
```

We know the paths because they were printed out by gdb above.
In the editor, search for the `tmpfs_mkdir` function and add the
following line there:

```
        printf("directory \"%s\" created by pid %d\n",
            cnp->cn_nameptr, curproc->p_pid);
```

Save the file and then, still in terminal 3, run:

```
$ ../../../../../../rumptools/rumpmake 
    compile  libtmpfs/tmpfs_vnops.o
    compile  libtmpfs/tmpfs_vnops.pico
      build  libtmpfs/librumpfs_tmpfs.a
      build  libtmpfs/librumpfs_tmpfs_pic.a
      build  libtmpfs/librumpfs_tmpfs.so.0.0
$ ../../../../../../rumptools/rumpmake install
    install  /home/pooka/tmp/demo/rr/buildrump.sh/rumptools/dest/usr/lib/librumpfs_tmpfs.a
    install  /home/pooka/tmp/demo/rr/buildrump.sh/rumptools/dest/usr/lib/librumpfs_tmpfs_pic.a
    install  /home/pooka/tmp/demo/rr/buildrump.sh/rumptools/dest/usr/lib/librumpfs_tmpfs.so.0.0
```

(Yes, the pathname to rumpmake isn't exactly convenient.  You would
normally for example put the rumptools directory in your PATH).

Now, we need to (re)start rump_server after building and installing
the driver.  In terminal 1, after having exited gdb, run rump_server as
we did above:

```
$ rm ctrl
$ rr/buildrump.sh/rump/bin/rump_server -lrumpfs_tmpfs -lrumpvfs -s unix://ctrl
```

(We need to remove the ctrl socket manually if we exit rump_server
in a violent fashion, like gdb does)

Then, in terminal 2, again mount the tmpfs file system and create
some directories in there.  Note that we have to re-mkdir /mnt,
since it's a new rump kernel instance and the root file system of
a rump kernel an in-memory file system:

```
rumpremote (unix://ctrl)$ mkdir /mnt
rumpremote (unix://ctrl)$ mount_tmpfs swap /mnt
rumpremote (unix://ctrl)$ mkdir /mnt/test1
rumpremote (unix://ctrl)$ mkdir /mnt/test2
rumpremote (unix://ctrl)$ mkdir /mnt/test37
```

Observe the prints in terminal 1:

```
directory "test1" created by pid 4
directory "test2" created by pid 5
directory "test37" created by pid 6
```

Less smooth sailing
-------------------

Rarely does kernel development go right the first time.  Let's do one more
thing where we add a further check to tmpfs_mkdir to ensure that the
kernel invariant of mkdir being called for an existing parent directory
holds.

In terminal 3, run your editor:

```
$ $EDITOR ../../../../fs/tmpfs/tmpfs_vnops.c
```

Add the following line below the print we added to tmpfs_vnops.c
earlier:

```
        if (dvp != NULL) panic("tmpfs_mkdir: parent directory is NULL");
```

Then, still in terminal 3, recompile and install as above.  Also,
restart the server and terminal 1 and mount the tmpfs file system
in terminal 2.  Then try to create a directory.  (Note, if you were
actually doing development, you would most likely write a script to
perform these steps so as to keep your iteration time short)

Now, looking into terminal 1, we see something alarming:

```
directory "test1" created by pid 4
panic: tmpfs_mkdir: parent directory is NULL
rump kernel halting...
halted
Aborted (core dumped)
```

What happened?  Let's examine the core to see (note, some systems
these days make it exceedingly difficult to get and/or find the core
files.  In that case, you can simply run rump_server in gdb).  In terminal 1:

```
$ gdb rr/buildrump.sh/rump/bin/rump_server core
GNU gdb (GDB) 7.6.1-ubuntu
[...]
(gdb) bt
[...]
#5  0x00007fa58e92601c in panic (fmt=<optimised out>)
    at /home/pooka/tmp/demo/rr/buildrump.sh/src/lib/librump/../../sys/rump/../kern/subr_prf.c:200
#6  0x00007fa58da42174 in tmpfs_mkdir (v=<optimised out>)
    at /home/pooka/tmp/demo/rr/buildrump.sh/src/sys/rump/fs/lib/libtmpfs/../../../../fs/tmpfs/tmpfs_vnops.c:823
#7  0x00007fa58e919b11 in VOP_MKDIR (dvp=0x1fd56f0, vpp=0x7fa585a29ca8, 
    cnp=<optimised out>, vap=<optimised out>)
    at /home/pooka/tmp/demo/rr/buildrump.sh/src/lib/librump/../../sys/rump/../kern/vnode_if.c:835
[...]
```

So the problematic change is in frame 6, where we made our edit.  Still
in terminal 1:

```
(gdb) frame 6
#6  0x00007fa58da42174 in tmpfs_mkdir (v=<optimised out>)
    at /home/pooka/tmp/demo/rr/buildrump.sh/src/sys/rump/fs/lib/libtmpfs/../../../../fs/tmpfs/tmpfs_vnops.c:822
822		if (dvp != NULL) panic("tmpfs_mkdir: parent directory is NULL");
(gdb) print dvp
$1 = (vnode_t *) 0x1fd56f0
```

Hmm, so dvp is not NULL, but ..... aaah, we accidentally inverted the
clause.  Boy were we careless!

Let's fix it to `if (dvp == NULL)`, recompile, reinstall and rerun
rump_server.  Yup, works now.

The best part is, after testing our changes and fixing bugs, we could
now simply compile `tmpfs_vnops.c` into a regular kernel.
