This page documents issues when wanting to run applications on top of a rump kernel without access to a standard OS features.  Examples of encompassed scenarios are [rumprun](https://github.com/rumpkernel/rumprun/) and [rumpuser-xen](https://github.com/rumpkernel/rumpuser-xen/).

## building

problem: no clear "recipe" to compile and bundle existing programs.

possible solution: provide a cross-compiler wrapper or specs or something that can be used just like a cross-compiler.

estimated effort: 1-2 days

## pthreads

problem: pthread interfaces are not supported.  This limits the ability to run existing programs.  Threads cannot be implemented in the rump kernel, but it is possible at the hypercall layer.

possible solution: implement the NetBSD kernel `_lwp_foo()` interfaces at the hypercall layer, and use NetBSD libpthread.  This approach avoids having to write libpthread from scratch.

estimated effort: 1-2 days

## nanosleep/gettimeofday/timing

problem: relevant syscalls are missing

possible solution: include relevant routines in rump kernel base

workaround: can already `nanosleep()` using `rump_sys_pollts()` (or equivalent)

estimated effort: 1 day

## signals

problem: there is no support for signal delivery.  Signals cannot be implemented in a rump kernel, but it is possible to implement them on the hypercall layer.

possible solution: just do it

estimated effort: 1 day