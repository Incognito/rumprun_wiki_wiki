This page describes [rump-pktgenif](http://repo.rumpkernel.org/rump-pktgenif/).

Rump-pktgenif is a test tool meant for measuring and
improving performance with packets traveling both up and down the stack.
The intent is that eventually it can be used especially in conjuction
with multicore scenarios.

Note: rump-pktgenif is a developer tool not meant for end users.

How to build & run
------------------

The tool depends on [buildrump.sh](http://repo.rumpkernel.org/buildrump.sh) and [rumprun](http://repo.rumpkernel.org/rumprun).  After you have those prerequisites built and install,
you can compile the tool by running `rumpmake` (located in the tooldir in the buildrump.sh build).
The, copy `tool/config.sh.example` to `tool/config.sh` and edit the path of `RUMPRUNDIR` in
that file.  After this, you are ready to run the tool.

Supported modes
---------------

The mode is given as the last parameter on the command line.

* send: application does `sendto()`, sink is interface
* recv: interface generates packets, sink is application `recvfrom()`
* route: L3 forwarding

Parameters:

* `-b`: burst size for packet generation
* `-c`: number of packets to generate or syscalls to execute (depends on mode). 0 == infinite
* `-p`: number of parallel operations to run (i.e. "multicore support").  Available only for "route" for now
* `-r`: location of rc script to configure networking stack (default: `./config.sh`)
* `-s`: packet or I/O size
