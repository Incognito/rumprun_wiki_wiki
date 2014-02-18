This page documents issues when wanting to run applications on top of a rump kernel without access to a standard OS features.  Examples of encompassed scenarios are [rumprun](https://github.com/rumpkernel/rumprun/) and [rumpuser-xen](https://github.com/rumpkernel/rumpuser-xen/).

## Compilation is not obvious

possible solution: provide a cross-compiler wrapper or specs or something that can be used just like a cross-compiler.

estimated effort: 1-2 days

## pthreads are not supported

possible solution: implement the NetBSD kernel _lwp_foo() interfaces, and use NetBSD libpthread.

estimated effort: 1-2 days

## nanosleep/gettimeofday/timing stuff is missing

possible solution: include relevant routines in rump kernel base

workaround: can already nanosleep() using rump_sys_pollts() (or equivalent)

estimated effort: 1 day