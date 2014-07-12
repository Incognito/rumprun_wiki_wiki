There is a compile-time variant of the [[POSIX userspace|Platforms: Userspace (POSIX Style)]] hypercall layer, not a complete layer and shares much code. The difference is that it uses fibers (cooperative userspace threads) rather than kernel level pthreads.

To compile this, use
```
./buildrump.sh -V RUMPUSER_THREADS=fiber -V RUMP_CURLWP=hypercall
```

This should run on any POSIX platform that has support for the `setcontext` calls, such as NetBSD, Linux glibc or FreeBSD. It should also be fairly easy to adapt to work on a bare metal platform as it has fewer dependencies.

Why?

1. For embedded systems that do not have a thread library and are single core
2. If you are running eg one network stack per core so threading is
not going to help
3. To cut down on amount of time spent on locks, as these become trivial.
4. If you have some other strange reason not to want  to run pthreads.
5. If you want to run a 100% deterministic kernel it is a good
starting point. If you adapt timestamps and random numbers to be
reproducible it should be identical.

Why not?

1. No parallelism. The NetBSD network stack is being made much for
multi processor friendly, so you might lose performance. The reduced locking may make up for this.
2. Some stuff currently missing - currently does not have the `rumpuser_sp` routines for remote calls, or virtual network devices. These issues should be resolved soon.
