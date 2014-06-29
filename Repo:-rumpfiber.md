This page discusses [rumpfiber](http://repo.rumpkernel.org/rumpfiber).

_Note this code is new and there are still a few portability issues to iron out. It is currently tested on Linux, NetBSD and FreeBSD, see Makefile for the small changes needed for build._

This is a rump kernel hypercall layer that does not use pthreads like the standard POSIX implementation in [buildrump.sh](http://repo.rumpkernel.org/buildrump.sh), but uses cooperative
userspace threads using the widely available `getcontext`/`swapcontext`
calls which create multiple stacks within a single OS thread.

It is based on a mix of the rump Xen and Minios code plus some of the
standard rumpuser code.

Why?

1. For embedded systems that do not have a thread library and are single core
2. If you are running eg one network stack per core so threading is
not going to help
3. To cut down on amount of time spent on locks, as these become trivial.
4. If you have some other strange reason not to want  to run pthreads.
5. If you want to run a 100% deterministic kernel it is a good
starting point. If you adapt timestamps and random numbers to be
reproducible it should be identical.
6. Not widely tested yet, but should be portable.

Why not?

1. No parallelism. The NetBSD network stack is being made much for
multi processor friendly, so you might lose performance.
2. Some stuff missing - I deleted eg the block device driver as it was
using threads, daemonize support etc. These are intended to be put
back, they just need some thought and were optional so were
temporarily removed.
3. Needs some namespacing cleanup.

To build, just do
````
make
````
This requires GNU make, so use `gmake` on a BSD system.

There are currently no build options other than tweaking the Makefile if needed.

It is currently tested using [ljsyscall](https://github.com/justincormack/ljsyscall).
