This page documents issues when wanting to run applications on top of a standalone rump kernel, i.e. use [rumprun](http://repo.rumpkernel.org/rumprun).

__Status__: Support is far along enough for people to be able to
experiment with their own applications using the offered tools.

## building

problem: no clear "recipe" to compile and bundle existing programs.

status: __DONE__'ish: "app-tools" can build off-the-internet software.
Still some tweaking, tuning, documenting and experimenting to be done.

## pthreads

status: __DONE__'ish: somewhat-complete support committed

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

The host will get SIGARLM, but the EINTR return value will not be
delivered (if host == userspace, at any rate).  The current resolve
on this is "won't fix", because it digs deep against the fundamentals
of a rump kernels.  There is "ongoing" debate on whether or not the
`rumpuser_kill()` hypercall should exist at all.
