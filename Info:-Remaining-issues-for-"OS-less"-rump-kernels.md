This page documents issues when wanting to run applications on top of a standalone rump kernel, e.g. [rumprun](http://repo.rumpkernel.org/rumprun/) and [rumpuser-xen](https://github.com/rumpkernel/rumpuser-xen/) scenarios.

## building

problem: no clear "recipe" to compile and bundle existing programs.

possible solution: provide a cross-compiler wrapper or specs or something that can be used just like a cross-compiler.

estimated effort: 1-2 days

status: ??? (ask @justincormack)

## pthreads

problem: pthread interfaces are not supported.  This limits the ability to run existing programs.  Threads cannot be implemented in the rump kernel (well, should not be), but it is possible outside of the rump kernel.

possible solution: implement the NetBSD kernel `_lwp_foo()` interfaces at the hypercall layer, and use NetBSD libpthread.  This approach avoids having to write libpthread from scratch.

estimated effort: 1-2 days

status: not even started

## nanosleep/gettimeofday/timing

problem: relevant syscalls are missing

status: __DONE__

## signals

problem: there is no support for signal delivery from a rump kernel.  Signals cannot be implemented in a rump kernel, but it is possible to implement them on the hypercall layer.

status: __DONE__'ish with `rumpuser_kill()`

CAVEAT: a rump kernel syscall with not be interrupted by a signal.  Consider e.g.

```
rump_sys_setitimer(...);
rv = rump_sys_poll(foo, 1, 0);
if (rv == EINTR) {...}
```

The host will get SIGARLM, but the EINTR return value will not be delivered (if host == userspace, at any rate).  The current resolve on this is "won't fix", because it digs deep against the fundamentals of a rump kernels.  There is "ongoing" debate on whether or not the `rumpuser_kill()` hypercall should exist at all.