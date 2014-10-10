This tutorial is meant as an up-to-date guide for people coming across rump kernels for the first time, and wanting to understand them and/or to use them.  There are two parts.  First we list a few items of suggested reading.  The second, and bulk, part of this tutorial is about playing around with the code.  People interested only in playing around with the code can [[skip the reading|Tutorial:-Getting-Started#hands-on]].

If you find this tutorial lacking in any way, please suggest improvements on the rump kernel mailing list (see the [[Community|Info:-Community]] page for more info on the list).

Reading
=======

The most succinct description of the architecture, motivation and history, including some use cases, is the ;login: magazine article "Rump Kernels: No OS? No Problem!".  You can find a free copy [here](http://rumpkernel.org/misc/usenix-login-2014/).

For more in-depth knowledge, reading [The Design and Implementation of the Anykernel and Rump Kernels](http://lib.tkk.fi/Diss/2012/isbn9789526049175/isbn9789526049175.pdf) is recommended.  Notably, read or skim chapters 2 and 3.  Since the book was written in 2011-2012, some parts will be out-of-date, but chapters 2 and 3 are still mostly accurate.  As a rule of thumb, if anything conflicts with the article we suggested to read first, that information is out-of-date in the book.  (we are working on an updated version of the book, which will hopefully be finished by the end of 2014).

After reading those, you should have a solid understanding of what and why a rump kernel is.  If you still want to study more, check out the [[Articles|Info: External articles, tutorials-and-howto's]] and [[Publications|Info: Publications and Talks]] pages on this wiki.

Hands on!
=========

We will go over the practical part in the comfort of userspace.  "Why userspace?", you ask.  First, it is the most convenient platform to do experimentation in.  Second, most concepts map more or less directly to embedded and cloud platforms, so it is even beneficial to get a hang of debugging and building and testing your projects in userspace before potentially moving them to the final target platform or platforms.

The following should work at least on more or less any Linux system and NetBSD systems.

Building
--------

First, we build the [[rumprun-posix|Repo:-rumprun-posix]] package.  This will give us four things we need for the rest of the tutorial:

* rump kernel components
* hypercall implementation for POSIX'y userspace (allows rump kernels to run in userspace)
* application stack support (allows POSIX applications, i.e. "userspace", to run on rump kernels)
* a selection of userland utilities, mostly configuration-oriented (think `ifconfig` etc.)

Note the subtle difference between the second and the third bullet point.  Essentially we are layering the rump kernel onto the host userspace, and a guest userspace on top of the rump kernel.  One might question why you would want to run a second userspace.  One valid scenario is when you want to use a rump kernel in userspace, e.g. as a userspace network stack -- you need the guest userspace for easy configuration of the rump kernel (again, think `ifconfig`).  We already mentioned a second valid scenario: to serve as a convenient testing/development platform and help you ramp up for embedded/cloud platforms.

In any case, the build is a matter of cloning the repo and running a script:

```
git clone http://repo.rumpkernel.org/rumprun-posix
cd rumprun-posix
./buildnb.sh
```

Trying it out
-------------

So we built things.  Now what?  Look into the `bin-rr` directory.  You will see a bunch of potentially familiar userland utilities, e.g. `ls`, `sysctl` and `ifconfig`.  Let's run one:

```
$ ./bin-rr/ls -l
total 2
drwxr-xr-x  2 0  0  512 Jul 28 19:53 dev
drwxrwxrwt  2 0  0  512 Jul 28 19:53 tmp
```

Not much there, huh?  That is because a rump kernel has a fictional root file system, and does not need any files to operate.  The `/dev` directory hosts device nodes, as normal, and the `/tmp` directory, while not strictly speaking necessary, is created for convenience, as some userspace utilities expect it to exist.

Now let's try to change the rump kernel's state using `sysctl`:

```
$ ./bin-rr/sysctl -w kern.hostname=myhostname
kern.hostname: rump-10564.watou -> myhostname
$ ./bin-rr/sysctl kern.hostname
kern.hostname = rump-10586.watou
```

Our change had no effect.  What's up?  In fact, the change did have effect, but what is happening here is that the rump kernel is hosted in the same process as the userspace utility we are running.  When the utility exits, so does the rump kernel.  When the second `sysctl` process runs, a new rump kernel is bootstrapped, and the `sysctl` command examines the newly bootstrapped rump kernel's state.  We can gauge two things out of this phenomenon: 1) bootstrapping a rump kernel is very fast 2) modifying the state of a kernel that will exit immediately is not very useful.  So what's the point?

If we again think about the scenario where rump kernels are used on an embedded device or cloud hypervisor, there is no mechanism for creating processes.  The necessary utilities will be baked into a single image and run most likely as threads.  Therefore, the problem does not exist in most target environments.  We could try baking things into a single image in userspace too, but continuous baking and testing is not the most convenient way when iterating and figuring things out.  Luckily, we have an ace up our sleeve in userspace: remote syscalls.  We can configure things so that the rump kernel lives as a server in one process, listens to remote requests, and applications make syscalls as remote requests.  This preserves a very natural usage, since the crash/exit of an application does not affect the rump kernel.

Going remote
------------

First, we need to start a server.  The build process creates one under `./rumpdyn/bin/rump_server`.  As a mandatory argument, the server takes an URL which indicates from where the server listens to for requests.  The easiest way is to use local domain sockets, which are identified by `unix://` and the remainder of the argument is the pathname.  Let's try it out:

```
$ ./rumpdyn/bin/rump_server unix:///tmp/rumpctrlsock
```

Ok, um, where did it go?  By default, a `rump_server` will background itself, and that is what happened here.  You can check that the server is running with `ps`.  You can even kill it with `kill`.  However, we will show a more civilized for the kill in a while.

Under the `bin` directory you can find the same utilities as in the `bin-rr` directory.  The difference between the two is that while the latter binaries have the entire kernel baked into them, the former only contain logic to contact a remote rump kernel.  You can verify this with the `ldd` utility.  The binaries in `bin` will be linked to librumpclient.

To direct the application to the right rump kernel server, the environment variable `$RUMP_SERVER` is used.  There is also a bash script, when if sourced, sets the prompt so that the value of `$RUMP_SERVER` is visible.  That will help keep track of which rump kernel server the commands are being sent to.  The script also sets `$PATH` so that the `bin` directory containing the applications build by rumprun-posix is first.  Let's give it a spin.

```
$ . ./rumpremote.sh
rumpremote (NULL)$ export RUMP_SERVER=unix:///tmp/rumpctrlsock
rumpremote (unix:///tmp/rumpctrlsock)$ $ sysctl -w kern.hostname=now_it_sticks
kern.hostname: rump-12224.watou -> now_it_sticks
rumpremote (unix:///tmp/rumpctrlsock)$ sysctl kern.hostname
kern.hostname = now_it_sticks
```

Sweet!  Let's use `ls` to see if the same files we observed earlier are still available.

```
rumpremote (unix:///tmp/rumpctrlsock)$ ls -l
ls: .: Function not implemented
```

Sour!  What's going on?  Rump kernels are component-oriented, which means that we must indicate which components we want the rump kernel to support.  When we ran `rump_server` earlier, we did not specify that it should support file systems.  No file systems, no `ls`.  So, let's halt the rump kernel and try again.

```
rumpremote (unix:///tmp/rumpctrlsock)$ halt
rumpremote (unix:///tmp/rumpctrlsock)$ ./rumpdyn/bin/rump_server -lrumpvfs unix:///tmp/rumpctrlsock
rumpremote (unix:///tmp/rumpctrlsock)$ ls -l
total 2
drwxr-xr-x  2 0  0  512 Jul 28 23:10 dev
drwxrwxrwt  2 0  0  512 Jul 28 23:10 tmp
rumpremote (unix:///tmp/rumpctrlsock)$ mount
rumpfs on / type rumpfs (local)
```

Better.  We'll get to how you're supposed to know about `-lrumpvfs` later in this tutorial.

Now, can we mount tmpfs inside the rump kernel server?

```
rumpremote (unix:///tmp/rumpctrlsock)$ mount_tmpfs /swap /tmp
mount_tmpfs: tmpfs on /tmp: Operation not supported by device
```

Bitter!  Looks like you'll have to keep reading this tutorial.

rumpremote extra tricks
-----------------------

Assuming you have sourced `rumpremote.sh`, you can list all of the available commands with `rumpremote_listcmds`.  Another way would be to list the contents of the `bin` directory.  You can test for an individual command with `rumpremote_hascmd` (which may give peace of mind if you e.g. want to execute `rm -rf /`).  Finally, you can "shell out" with `rumpremote_hostcmd`.  Let's try these out.

```
rumpremote (unix:///tmp/rumpctrlsock)$ rumpremote_listcmds 
arp		ed		mknod		newfs_msdos	route
[...]
rumpremote (unix:///tmp/rumpctrlsock)$ rumpremote_hascmd ls
#t
rumpremote (unix:///tmp/rumpctrlsock)$ rumpremote_hascmd top
#f
rumpremote (unix:///tmp/rumpctrlsock)$ ls -l /
total 2
drwxr-xr-x  2 0  0  512 Jul 28 23:10 dev
drwxrwxrwt  2 0  0  512 Jul 28 23:10 tmp
rumpremote (unix:///tmp/rumpctrlsock)$ rumpremote_hostcmd ls -l /
total 110
drwxr-xr-x   2 root root  4096 Jul 23 23:01 bin
[...]
```

Note: shell redirects or `cd` will not work with rumpremote.  The behaviour expected -- the shell is running in host userspace, not guest userspace -- but needs to be taken into account.

```
rumpremote (unix:///tmp/rumpctrlsock)$ cd /dev
ERROR: cd not available in rumpremote mode /dev
rumpremote (unix:///tmp/rumpctrlsock)$ echo messages from earth > /file
bash: /file: Permission denied
rumpremote (unix:///tmp/rumpctrlsock)$ ls -l /file
ls: /file: No such file or directory
rumpremote (unix:///tmp/rumpctrlsock)$ echo messages from earth | dd of=/file
0+1 records in
0+1 records out
20 bytes transferred in 0.001 secs (20000 bytes/sec)
rumpremote (unix:///tmp/rumpctrlsock)$ ls -l /file
-rw-r--r--  1 0  0  20 Jul 29 04:24 /file
```

Coping with components
----------------------

Let's assume we want to run some driver in a rump kernel.  That driver needs all of its dependencies to work.  How to figure out what the dependencies are?  For the impatient, there is `rump_allserver`, which simply loads all components that were available when `rump_allserver` was built.  However, it is better to get into the habit of surgically selecting only the necessary components.  This will keep footprint of the rump kernel to a minimum.  We can use the tool `rump_wmd` (Where's My Dependency) to resolve dependencies.  For example, let's assume we want a rump kernel to support the FFS file system driver.

```
rumpremote (unix:///tmp/rumpctrlsock)$ rumpremote_hostcmd ./rumpdyn/bin/rump_wmd -L./rumpdyn/lib -lrumpfs_ffs
DEBUG0: Searching component combinations. This may take a while ...
DEBUG0: Found a set
-lrumpdev -lrumpdev_disk -lrumpvfs -lrumpfs_ffs
```

Now, we could start a rump kernel server with FFS, but we'll actually start one which supports tmpfs, to not have to magically come up with an FFS image to mount.  Before we can start another server, we have to halt the previously running one.  Note, you can halt a server only once, as demonstrated below.

```
rumpremote (unix:///tmp/rumpctrlsock)$ halt
rumpremote (unix:///tmp/rumpctrlsock)$ halt
rumpclient init failed
rumpremote (unix:///tmp/rumpctrlsock)$ ./rumpdyn/bin/rump_server -lrumpfs_tmpfs -lrumpvfs unix:///tmp/rumpctrlsock
rumpremote (unix:///tmp/rumpctrlsock)$ mount_tmpfs /swap /tmp
rumpremote (unix:///tmp/rumpctrlsock)$ mount
rumpfs on / type rumpfs (local)
tmpfs on /tmp type tmpfs (local)
```

Building your own applications
------------------------------

So you can run rump kernels with various component configurations and change their configurations using various applications we provided.  The next thing you are probably thinking about is bundling your own applications instead of the ones we provide.  Short answer: it's possible (obviously, see above), but we're still working on how to make it "consumer grade".  Some experiments are currently done on the [[Xen platform|Repo:-rumprun-xen]], where it is possible to build application stacks using wrappers to the `configure` and `make` build tools.  Have a look in the [app-tools directory](https://github.com/rumpkernel/rumprun-xen/tree/master/app-tools) and at what the Travis CI [automated test script](https://github.com/rumpkernel/rumprun-xen/blob/master/.travis.yml) does.

Rest assured, we will write more documentation on the subject as the material develops and the plot thickens.


Homework
--------

Try out at least some of the commands listed by `rumpremote_listcmds`.  Some of them require rather specially configured rump kernels (e.g. `wpa_supplicant`), and those are out of the scope of this tutorial.  However, you should for example be able to configure a rump server up to a point where `ping 127.0.0.1` works.

The manual pages for all of the commands are available at http://man.netbsd.org/

When you are satisfied with your prowess, move on to for example the [[kernel development|Tutorial:-Kernel-development]] tutorial, which discusses running rump kernels under the debugger.
