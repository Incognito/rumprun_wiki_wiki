This page describes [netmap-rumptcpip](http://repo.rumpkernel.org/netmap-rumptcpip).

netmap-rumptcpip uses a rump kernel to provide a userspace TCP/IP stack for use with the
[netmap](http://info.iet.unipi.it/~luigi/netmap/) packet processing framework.

Build instructions
------------------

If your netmap headers are not in `/usr/include`, set the env
variable `NETMAPINCS` to point to the right place, e.g.
`export NETMAPINCS=/home/pooka/netmap/sys`.  Then run:

* `git submodule update --init`
* `./buildrump.sh/buildrump.sh -T rumptools -s rumpsrc`
* `(cd libnetmapif ; ../rumptools/rumpmake dependall && ../rumptools/rumpmake install)`


Use examples
------------

Go to `examples` and compile with `make`.  Then configure one TCP/IP
stack with the address 1.2.3.4, another with the address 1.2.3.5, and
connect them to each other via the VALE virtual switch:

- `./netmapcat vale:1 1.2.3.4 listen 1`
- `./netmapcat vale:2 1.2.3.5 connect 1.2.3.4 1`

Observe whatever you type in the latter terminal magically(?) appear in
the other one.

By replacing `vale:x` with a real interface name, e.g. `ix0`, you should
be able to bind to a physical network interface and access the wire.