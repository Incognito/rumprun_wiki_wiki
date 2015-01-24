The page describes the [rumprun-baremetal repository](http://repo.rumpkernel.org/rumprun-baremetal).

Rumprun-baremtal provides rump kernel support on raw hardware, and by extension hypervisors on the cloud.  The repository includes the "OS" required for booting the hardware up to the state where running rump kernels is possible, the hypercalls for making the rump kernel function, and furthermore the enabling bits for running POSIX applications on top of the rump kernel.

Building
--------

Generally, assuming you are building on x86, the following should work:

```
sh buildme.sh -- -F ACLFLAGS=-m32
```

Other targets
-------------
Other targets are not yet supported, so if you want to build for those, you need to write the
machine dependent parts.  (patches very welcome ;-)

Creating a bootable ISO image with grub
---------------------------------------

Run `make iso`.  You will need `xorriso` and `grub-mkrescue` installed on your build host.

VirtualBox
----------
If you want to run the iso in VirtualBox be sure to go into the VM settings -> Network -> Adapter 1 -> Advanced -> Adapter Type and select the 82540EM, or you can try one of the other Intel ones.

Running
-------

Run the resulting image just like you would any other OS with e.g. QEMU or VirtualBox.

Alternatively, you can copy the result of `make iso` to a USB flash drive and boot on hardware.
Notably, by default there is only very limited network driver support in the default image, so do not
expect things to automatically work on any system you can find.