A rump kernel is designed to run anywhere with sensible defaults.  This page documents compile options that improve runtime performance.


###  remove assertions

Run `buildrump.sh` with either `-V RUMP_DIAGNOSTIC=no` or `-r` (the latter also removes `-g`, which will result in smaller binaries).  This will eliminate invariant assertions from the rump kernel, and can improve performance about 5%.


### static linking

Dynamic linking is slower than static linking due to added indirections in resolving symbol addresses at runtime.  One option is to compile the application binary the completely statically (`rumpmake LDSTATIC=-static`).  Another option is to include only static components in your rump kernel installation by running `buildrump.sh` with `-V MKPIC=no`.


### locking scheme

If you are planning to run rump kernels with exactly 1 virtual core configured (`RUMP_NCPU=1`), run `buildrump.sh` with `-V RUMP_LOCKS_UP=yes`.  This will optimize away most memory bus locks.