This tutorial explains the very basic concepts of rump kernels.  We will go over them in the comfort of userspace.  "Why userspace?", you ask.  First, it is the most convenient platform to do experimentation in.  Second, most concepts map more or less directly to embedded and cloud platforms, so it is even beneficial to get a hang of debugging and building your projects in userspace before potentially moving them to the final target platform or platforms.

Building
========

First, we build the [[rumprun|Repo:-rumprun]] package.  This will give us four things we need for the rest of the tutorial:

* rump kernel components
* hypercall implementation for POSIX'y userspace (allows rump kernels to run in userspace)
* application stack support (allows POSIX applications, i.e. "userspace", to run on rump kernels)
* a selection of userland utilities

Note the subtle difference between the second and the third bullet point.  Essentially we are layering the rump kernel onto the host userspace, and a guest userspace on top of the rump kernel.  One might question why you would want to run a second userspace.  One valid scenario is when you want to use a rump kernel in userspace, e.g. as a userspace network stack.  We already mentioned the second valid scenario: to serve as a convenient testing/development platform and help you ramp up for embedded/cloud platforms.

In any case, the build is a matter of running a script:

```
git clone http://repo.rumpkernel.org/rumprun
cd rumprun
./buildnb.sh
```

Trying it out
=============

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

If we again think about the scenario where rump kernels are used on an embedded device or cloud hypervisor, there is no mechanism for creating processes.  The necessary utilities will be baked into a single image and run most likely as threads.  Therefore, the problem does not exist in most target environments.  Luckily, we have an ace up our sleeve in userspace: remote syscalls.  We can configure things so that the rump kernel lives as a server in one process, listens to remote requests, and applications make syscalls as remote requests.  This preserves a very natural usage, since the crash/exit of an application does not affect the rump kernel.

Going remote
============

First, we need to start a server.  The build process creates one under `./rumpdyn/bin/rump_server`.  As a mandatory argument, the server takes an URL which indicates from where the server listens to for requests.  The easiest way is to use local domain sockets, which are identified by `unix://` and the remainder of the argument is the pathname.  Let's try it out:

```
$ ./rumpdyn/bin/rump_server unix:///tmp/rumpkernsock
```

Ok, um, where did it go?  By default, a `rump_server` will background itself, and that is what happened here.  You can check that the server is running with `ps`.  You can even kill it with `kill`.  However, we will show a more civilized way next.

Under the `bin` directory you can find the same utilities as in the `bin-rr` directory.  The difference between the two is that while the latter binaries have the entire kernel baked into them, the former only contain logic to contact a remote rump kernel.  You can verify this with the `ldd` utility.  The binaries in `bin` will be linked to librumpclient.

To direct the application to the right rump kernel server, the environment variable `$RUMP_SERVER` is used.  There is also a bash script, when if sourced, sets the prompt so that the value of `$RUMP_SERVER` is visible.  The script also sets `$PATH` so that the `bin` directory is first.  Let's give it a spin.

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

Better.