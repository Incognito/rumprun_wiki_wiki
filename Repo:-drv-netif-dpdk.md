This page describes [drv-netif-dpdk](http://repo.rumpkernel.org/drv-netif-dpdk).

drv-netif-dpdk is a [DPDK](http://dpdk.org) network interface for [rump
kernels](http://rumpkernel.org).  The combined result is a TCP/IP stack
doing packet I/O via DPDK.

in diagram form:

        ------------------------------
        |    application process     |
        ||--------------------------||
        || rump kernel (TCP/IP etc.)||
        ||--------------------------||
        || drv-netif-dpdk (dpdkif)  ||
        ||--------------------------||
        || DPDK                     ||
        |----------------------------|
        -----------------------------|


Instructions
------------

The simple version is as follows:

* `./buildme.sh`

To test, try running `rump/bin/webbrowser`.

By default, the build will use the DPDK submodule in this repository.
You can also choose another DPDK installation, just set `$RTE_SDK` and
`$RTE_TARGET` differently.  You can now link and use the DPDK interface
driver (`librumpnet_dpdkif`, `-lrumpnet_dpdkif`) into applications.

Using the revision of DPDK included as a submodule is highly recommended.
It is possible to use another version of DPDK, but in that case be
aware that the combination may not be tested, and you should prepare to
debug and fix any resulting problems yourself.

For more information on how to use the resulting userspace TCP/IP stack,
see e.g. the [buildrump.sh repo](https://github.com/rumpkernel/buildrump.sh)
or http://rumpkernel.org/.  To portably configure the TCP/IP stack,
using [rumpctrl](http://repo.rumpkernel.org/rumpctrl) is recommended.
There are some very simple examples in the `examples` directory.

__NOTE__: To successfully use the TCP/IP stack, you must have the host correctly
configured for running DPDK.  This means you have to the appropriate host
kernel configurations set and the necessary kernel modules loaded.  These
steps are not documented here.  Consult DPDK documentation.
