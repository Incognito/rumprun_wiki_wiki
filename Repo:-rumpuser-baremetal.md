The page describes the [rumpuser-baremetal repository](http://repo.rumpkernel.org/rumpuser-baremetal).

Rumpuser-baremtal provides rump kernel support on raw hardware, and by extension hypervisors on the cloud.  The repository includes the "OS" required for booting the hardware up to the state where running rump kernels is possible, the hypercalls for making the rump kernel function, and furthermore some enabling bits for running POSIX applications on top of the rump kernel.

Building
--------

Building is not yet consumer-grade, but for the brave: read and edit 
`buildme.sh`, then edit `Makefile` and execute:

```
sh buildme.sh
make
```

Creating a bootable ISO image with grub
---------------------------------------

Follow [the instructions at OSDev](http://wiki.osdev.org/Bare_Bones#Building_a_bootable_cdrom_image) and use the file `rk.bin` instead of `myos.bin`.

VirtualBox
----------
If you want to run the iso in VirtualBox be sure to go into the VM settings -> Network -> Adapter 1 -> Advanced -> Adapter Type and select the 82540EM, or you can try one of the other Intel ones.

Running
-------

Run the resulting image just like you would any other OS with e.g. QEMU or VirtualBox.