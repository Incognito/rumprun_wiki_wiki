I work on many things.  Some sort of wishfully-thought short-term TODO list:

* fix _exit() to deal with threads [rumprun]
* unify the kernel and application memory pools [rumprun] \(__progressing__)
   + step 1: introducing the "caller id" to allocators. _done_
   + step 2: unifying the page allocator between platforms. _done_
   + step 3: splitting the page allocator into zones. _not done_
   + step 4: introducing a rump kernel call to deal with external memory backpressure. _not done_ 
   + step 5: defining appropriate limits and introducing necessary heuristics. _not done_
* support fork(), low'ish priority without an immediate use case [rumprun]
* ARM support [rumprun]
* fix build to support object directories [rumprun, rumpctrl]
* re-abstract sysproxy transport to allow for non-socket implementations [rump kernels]
* fix all bugs [everywhere] \(might take a while)