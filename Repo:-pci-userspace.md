This wiki page describes [pci-userspace](http://repo.rumpkernel.org/pci-userspace).

The repository contains support for running NetBSD kernel PCI device drivers in rump kernels in userspace.  Support is generic, so more or less any device driver could work, though currently
the build infra offers only a handful of drivers.

Supported platforms
-------------------

* Linux (via uio_pci_generic).  PCI I/O space is not yet supported, so only devices with memory space registers will work.  Also, devices with only MSI/MSI-X interrupts are not supported (limitation of uio_pci_generic).

Building
--------

The build procedure is standard in that it's done using `rumpmake`.

As of writing this, you need a buildrump.sh build which uses
NetBSD HEAD sources (HEAD as of when you're reading this text ;-).  We will
not cover that here, it's documented in the
[[buildrump.sh wiki|Repo:-buildrump.sh#tips-for-advanced-users]].

To build the drivers, run `rumpmake` from
[[buildrump.sh|repo:-buildrump.sh]] in the repo's `src` subdirectory:

```
src$ rumpmake dependall
src$ rumpmake install
```

Then, if you want, you can build the examples:

```
examples$ rumpmake dependall
```

Running
-------

There are two parts to running.

First, your host must be configured correctly for the rump kernel to be able to access the desired PCI device.  That part is documented [[here|Howto:-Accessing-PCI-devices-from-userspace]].

Second, you must configure the rump kernel to do whatever you want to do with the device.
That is a very open-ended task, but for example configuring a 802.11 adapter to access
a WPA-protected network is documented [[here|Howto:-Configuring-a-802.11-device]].
