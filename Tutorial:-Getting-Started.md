This tutorial is meant as an up-to-date guide for people coming across rump kernels for the first time, and wanting to understand them and/or to use them.  There are two parts.  First we list a few items of suggested reading.  The second, and bulk, part of this tutorial is about playing around with the code.  People interested only in playing around with the code can [[skip the reading|Tutorial:-Getting-Started#hands-on]].

If you find this tutorial lacking in any way, please suggest improvements on the rump kernel mailing list (see the [[Community|Info:-Community]] page for more info on the list).

Reading
=======

The most succinct description of the architecture, motivation and history, including some use cases, is the ;login: magazine article "Rump Kernels: No OS? No Problem!".  You can find a free copy [here](http://rumpkernel.org/misc/usenix-login-2014/).

For more in-depth knowledge, reading [The Design and Implementation of the Anykernel and Rump Kernels](http://lib.tkk.fi/Diss/2012/isbn9789526049175/isbn9789526049175.pdf) is recommended.  Notably, read or skim chapters 2 and 3.  Since the book was written in 2011-2012, some parts will be out-of-date, but chapters 2 and 3 are still mostly accurate.  As a rule of thumb, if anything conflicts with the article we suggested to read first, that information is out-of-date in the book.  (we are working on an updated version of the book, which will hopefully be finished by the end of 2015).

After reading those, you should have a solid understanding of what and why a rump kernel is.  If you still want to study more, check out the [[Articles|Info: External articles, tutorials-and-howto's]] and [[Publications|Info: Publications and Talks]] pages on this wiki.

Hands on!
=========

We will go over the practical part in the comfort of userspace.  "Why userspace?", you ask.  First, it is the most convenient platform to do experimentation in.  Second, most concepts map more or less directly to embedded and cloud platforms, so it is even beneficial to get a hang of debugging and building and testing your projects in userspace before potentially moving them to the final target platform or platforms.

The following should work at least on more or less any Linux system and NetBSD systems.

Building
--------

First, we do a full build of the [[buildrump.sh|Repo:-buildrump.sh]] package.  This will give us two things we need for the rest of the tutorial:

* rump kernel components (i.e. the building blocks of rump kernels)
* hypercall implementation for POSIX'y userspace (allows rump kernels to run in userspace)

A kernel alone is slightly boring.  We will also need the [[rumpctrl|Repo:-rumpctrl]] package, which will give us the ability to interact with rump kernel instances:

* a selection of userland utilities, mostly configuration-oriented (think `ifconfig` etc.)
* a transport mechanism for the userland utilities to communicate with remote rump kernels

Notably, the `buildrump.sh` stage is necessary only if you want to run rump kernels in userspace, but `rumpctrl` is useful no matter which platform you run your production rump kernels on (Xen, KVM, ...).

In more concrete terms, for `buildrump.sh`:

```
git clone http://repo.rumpkernel.org/buildrump.sh
cd buildrump.sh
./buildrump.sh
```

And for `rumpctrl`:

```
git clone http://repo.rumpkernel.org/rumpctrl
cd rumpctrl
./buildnb.sh
```

(Notably, the above process is slightly wasteful in terms of bandwidth usage and will clone the `src-netbsd` repository twice.  Advanced users can clone the repository manually and use the `-s` argument to the build scripts to specify the location.  However, we opted for simplicity in this tutorial.)


Trying it out
-------------

So we built things.  Now what?  Let's assume you've changed back to the top level directory (i.e. `cd ..` after the last build command).  Look into the `./rumpctrl/bin` directory.  You will see a bunch of potentially familiar userland utilities, e.g. `ls`, `sysctl` and `ifconfig`.  What happens if we try to run one?

```
$ ./rumpctrl/bin/ifconfig 
error: RUMP_SERVER not set
rumpclient init failed
```

Fail happens.  Why?  On a regular system, each userland utility communicates implicitly with the host kernel.  For example, when you run `ls`, the utility makes the appropriate system calls to the host kernel.  However, there is no implicit rump kernel.  That is the reason why we must explicitly tell the rumpctrl utilities which rump kernel we wish for it to communicate with.  That information is conveyed by an URL in the `RUMP_SERVER` environment variable.  To know the right URL to set, we must first start a rump kernel server.

If you followed the above build process, you will have a rump kernel server available under `./buildrump.sh/rump/bin/rump_server`.  As a mandatory argument, the server takes an URL which indicates from where the server listens to for requests.  The easiest way is to use local domain sockets, which are identified by `unix://` and the remainder of the argument is the pathname.  Let's try it out:

```
$ ./buildrump.sh/rump/bin/rump_server unix:///tmp/rumpctrlsock
```

Ok, um, where did it go?  By default, a `rump_server` will background itself, and that is what happened here.  You can check that the server is running with `ps`.  You can even kill it with `kill`.  However, we will show a more civilized for the kill in a while.

You can set `$RUMP_SERVER` manually to the URL you specified when you ran the server.  There is also a bash script, when if sourced, sets the prompt so that the value of `$RUMP_SERVER` is visible.  That will help keep track of which rump kernel server the commands are being sent to.  The script also sets `$PATH` so that the `bin` directory containing the applications build by rumpctrl is first.  Let's give it a spin.

```
$ . ./rumpctrl.sh
rumpctrl (NULL)$ export RUMP_SERVER=unix:///tmp/rumpctrlsock
rumpctrl (unix:///tmp/rumpctrlsock)$ $ sysctl -w kern.hostname=look_at_them_run
kern.hostname: rump-12224.watou -> look_at_them_run
rumpctrl (unix:///tmp/rumpctrlsock)$ sysctl kern.hostname
kern.hostname = look_at_them_run
```

Sweet!  Let's use `ls` to see what files the rump kernel is hosting.

```
rumpctrl (unix:///tmp/rumpctrlsock)$ ls -l
ls: .: Function not implemented
```

Sour!  What's going on?  Rump kernels are component-oriented, which means that we must indicate which components we want the rump kernel to support.  When we ran `rump_server` earlier, we did not specify that it should support file systems.  No file systems, no `ls`.  So, let's halt the rump kernel and try again.

```
rumpctrl (unix:///tmp/rumpctrlsock)$ halt
rumpctrl (unix:///tmp/rumpctrlsock)$ ./buildrump.sh/rump/bin/rump_server -lrumpvfs unix:///tmp/rumpctrlsock
rumpctrl (unix:///tmp/rumpctrlsock)$ ls -l
total 2
drwxr-xr-x  2 0  0  512 Jul 28 23:10 dev
drwxrwxrwt  2 0  0  512 Jul 28 23:10 tmp
rumpctrl (unix:///tmp/rumpctrlsock)$ mount
rumpfs on / type rumpfs (local)
```

Better.  We'll get to how you're supposed to know about `-lrumpvfs` later in this tutorial.

Now, can we mount tmpfs inside the rump kernel server?

```
rumpctrl (unix:///tmp/rumpctrlsock)$ mount_tmpfs /swap /tmp
mount_tmpfs: tmpfs on /tmp: Operation not supported by device
```

Bitter!  Looks like you'll have to keep reading this tutorial.

rumpctrl extra tricks
---------------------

Assuming you have sourced `rumpctrl.sh`, you can list all of the available commands with `rumpctrl_listcmds`.  Another way would be to list the contents of the `bin` directory.  You can test for an individual command with `rumpctrl_hascmd` (which may give peace of mind if you e.g. want to execute `rm -rf /`).  Finally, you can "shell out" with `rumpctrl_hostcmd`.  Let's try these out.

```
rumpctrl (unix:///tmp/rumpctrlsock)$ rumpctrl_listcmds 
arp		ed		mknod		newfs_msdos	route
[...]
rumpctrl (unix:///tmp/rumpctrlsock)$ rumpctrl_hascmd ls
#t
rumpctrl (unix:///tmp/rumpctrlsock)$ rumpctrl_hascmd top
#f
rumpctrl (unix:///tmp/rumpctrlsock)$ ls -l /
total 2
drwxr-xr-x  2 0  0  512 Jul 28 23:10 dev
drwxrwxrwt  2 0  0  512 Jul 28 23:10 tmp
rumpctrl (unix:///tmp/rumpctrlsock)$ rumpctrl_hostcmd ls -l /
total 110
drwxr-xr-x   2 root root  4096 Jul 23 23:01 bin
[...]
```

In case you are wondering if we should have used `rumpctrl_hostcmd` to run
`rump_server` when we restarted it, you are on the right track.  We did not
do that because `rumpctrl_hostcmd` had not been introduced yet and because
we are sure that the is no `rump_server` rumpctrl command (well, at least
__I__ am sure).

Note: shell redirects or `cd` will not work with rumpctrl.  The behaviour expected -- the shell is running in host userspace, not guest userspace -- but needs to be taken into account.

```
rumpctrl (unix:///tmp/rumpctrlsock)$ cd /dev
ERROR: cd not available in rumpctrl mode /dev
rumpctrl (unix:///tmp/rumpctrlsock)$ echo messages from earth > /file
bash: /file: Permission denied
rumpctrl (unix:///tmp/rumpctrlsock)$ ls -l /file
ls: /file: No such file or directory
rumpctrl (unix:///tmp/rumpctrlsock)$ echo messages from earth | dd of=/file
0+1 records in
0+1 records out
20 bytes transferred in 0.001 secs (20000 bytes/sec)
rumpctrl (unix:///tmp/rumpctrlsock)$ ls -l /file
-rw-r--r--  1 0  0  20 Jul 29 04:24 /file
```

Coping with components
----------------------

Let's assume we want to run some driver in a rump kernel.  That driver needs all of its dependencies to work.  How to figure out what the dependencies are?  For the impatient, there is `rump_allserver`, which simply loads all components that were available when `rump_allserver` was built.  However, it is better to get into the habit of surgically selecting only the necessary components.  This will keep footprint of the rump kernel to a minimum and also allow you to include drivers which were built and installed separate from `rump_allserver`.  We can use the tool `rump_wmd` (Where's My Dependency) to resolve dependencies.  For example, let's assume we want a rump kernel to support the FFS file system driver.

```
rumpctrl (unix:///tmp/rumpctrlsock)$ rumpctrl_hostcmd ./buildrump.sh/rump/bin/rump_wmd -L./buildrump.sh/rump/lib -lrumpfs_ffs
DEBUG0: Searching component combinations. This may take a while ...
DEBUG0: Found a set
-lrumpdev -lrumpdev_disk -lrumpvfs -lrumpfs_ffs
```

Now, we could start a rump kernel server with FFS, but we'll actually start one which supports tmpfs, to not have to magically come up with an FFS image to mount.  Before we can start another server, we have to halt the previously running one.  Note, you can halt a server only once, as demonstrated below.

```
rumpctrl (unix:///tmp/rumpctrlsock)$ halt
rumpctrl (unix:///tmp/rumpctrlsock)$ halt
rumpclient init failed
rumpctrl (unix:///tmp/rumpctrlsock)$ rumpctrl_hostcmd ./buildrump.sh/rump/bin/rump_server -lrumpfs_tmpfs -lrumpvfs unix:///tmp/rumpctrlsock
rumpctrl (unix:///tmp/rumpctrlsock)$ mount_tmpfs /swap /tmp
rumpctrl (unix:///tmp/rumpctrlsock)$ mount
rumpfs on / type rumpfs (local)
tmpfs on /tmp type tmpfs (local)
```

If you want, as an exercise create an ISO image and use a `rump_server`
and the `rumpfs_cd9660` driver to access the contents.  You will need
to use the `-d` argument to `rump_server` to map the image to the
rump kernel namespace.  Check out the
[rump server manpage](http://man.netbsd.org/cgi-bin/man-cgi?rump_server++NetBSD-current)
if you need more information about the `-d` parameter.

Building your own applications
------------------------------

So you can run rump kernels with various component configurations
and change their configurations using various applications we
provided.  The next thing you are probably thinking about is
bundling your own applications instead of the ones we provide.
Short answer: it's possible (obviously, see above), but we're still
working on how to make it "consumer grade".  Some experiments
are currently done on the [[bare metal and Xen platforms|Repo:-rumprun]],
where it is possible to build rumprun unikernels using wrappers to
the `configure` and `make` build tools.  See the [[rumprun|Repo:-rumprun]]
wiki page for current information on the subject.


Homework
--------

Try out at least some of the commands listed by `rumpctrl_listcmds`.  Some of them require rather specially configured rump kernels (e.g. `wpa_supplicant`), and those are out of the scope of this tutorial.  However, you should for example be able to configure a rump server up to a point where `ping 127.0.0.1` works.

The manual pages for all of the commands are available at http://man.netbsd.org/

When you are satisfied with your prowess, move on to for example the [[kernel development|Tutorial:-Kernel-development]] tutorial, which discusses running rump kernels under the debugger.
