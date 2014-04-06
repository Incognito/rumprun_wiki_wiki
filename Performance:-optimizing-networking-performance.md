This page describes ideas -- and, in the future, experiences -- in optimizing the performance of the TCP/IP packet processing done by DPDK + rump kernels.  The page is work in progress and lists only potential avenues, not facts.  Feel more than free to contribute.  The rest of page assumes that the reader is familiar with the basic architecture of rump kernels (as described in "The Design and Implementation of the Anykernel and Rump Kernels").

The issue to understand is that while the TCP/IP stack is stable, it is the unmodified NetBSD kernel TCP/IP stack and therefore attempts to conform to the rules of TCP/IP processing in the kernel.  The task of the kernel is to provide fair resource sharing (FSVO "fair") to any potential user/application running on the system.  This means abstracting constraints, and can lead to loss of information.  On the contrary, a userspace TCP/IP stack in conjunction with an application can be aggressively optimized for the needs of the application.  The rhetoric "userspace TCP/IP is fast because it avoids data copying" is only one manifestation of that phenomenon (namely, the TCP/IP stack knows where data should be delivered).

Some suggestions for code level modifications follow.

Soft interrupts
---------------

The kernel uses soft interrupts to defer interrupt processing from a hardware interrupt handler to a more schedulable processing context.  DPDK uses polling to access the NIC, so there are not fastpath interrupts.  At any rate, all interrupts in rump kernels are scheduled, so scheduling an "interrupt" to schedule an "interrupt" is ... redundant.  Yet, we must make sure we adhere to all of the semantics of softints if we wish the NetBSD kernel TCP/IP stack to work properly (believe me, I tried to cheat there and got my stack kicked ...)

One idea on how to remove softints without upsetting the NetBSD drivers is to add the concept of hardware interrupt threads to rump kernels (no, really, it's not as oxymoronic as it sounds; keep reading).  Then we just add a check for a hardware interrupt thread along the unschedule path.  If a hardware interrupt thread is unscheduling, softint handlers should be run.  As a detail, at some level the "max one outstanding softint handler per level core" invariant needs to be enforced.  As a bonus, the approach will get rid of the softint threads, which contribute to a large amount of bootstrap overhead and memory use.  On paper, this idea is so simple and effective that I'm really wondering why I didn't think of it and implement it years ago ...

Optimizing lock and cache behavior
----------------------------------

A big problem with multiprocessor scaling is dealing with data locality with respect to caches.  Furthermore, intercore locking is expensive.  Addressing these two issues with rump kernels is fairly trivial because a rump kernel is entirely scheduled by the host and furthermore follows a run-to-completion model.  If it is feasible to partition TCP/IP connections so that a certain subset can be handled entirely on one virtual core (i.e. the rump kernel's idea of a "CPU"), the fastpath of every lock inside rump kernel can be optimized to a regular memory access with a compile-time optimization.  Furthermore, if the host threads used in one rump kernel instance can be pinned a single physical core and made to use non-preemptive scheduling, all locks and cache contention can be optimized away.

curlwp (*DONE*)
---------------

In the NetBSD kernel, `curlwp` resolves to the currently executing thread.  It is invoked often in NetBSD kernel and is expected to be fast.  The implementation is machine dependent, but some examples include reserving a dedicated register for storing the necessary pointer or setting up VM suitably so that the pointer can be resolved by accessing a constant memory address.  Currently, a rump kernel running on a POSIX host uses pthread TLS to handle `curlwp`.  Going through libpthread via a hypercall is relatively speaking slow, thus prompting the optimization of `curlwp`.  On architectures with a large register bank, the fast path for `curlwp` can be implemented by using a dedicated register, but on architectures such as x86 some other approach is required.

The "done" part:
Since March 2014, RUMP_CURLWP can be used to control how `curlwp` is referenced.  The default, if the platform supports TLS, is to use `__thread` in the rump kernel instead of a hypercall.