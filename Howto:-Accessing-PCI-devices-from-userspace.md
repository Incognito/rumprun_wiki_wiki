This howto explains how to configure your host system so that PCI devices are
available to drivers running in userspace rump kernels.

Linux hosts
-----------

The DMA memory allocator uses hugepages to allocate physically contiguous
"DMA-safe" memory.  Make sure you have a decent amount of hugepages
available on your system.  Something like this should do the trick:


```
echo 64 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
```

Though, of course, check the value first, and the value of
`free_hugepages` in the same directory.  "Decent amount" is difficult to
define exactly in generic terms.  If the driver wants no hugepages, one or
more, is up to each individual driver.  For example, _wm_ GigE NIC driver
requires one hugepage.  You know you need more if you see an error like:

```
iwn0: could not allocate TX ring DMA memory
```

Then, load the _uio_pci_generic_ Linux kernel module, which will be used
by the rump kernel to access the device.

```
$ modprobe uio_pci_generic
```

Now, figure out the info of the device which you want to attach to,
e.g. using `lspci`.  Let's assume it's bus 3, device 0, function 0 (which
just might be where our target device is located on this laptop):

```
$ lspci -v -nn -s 03:00.0
03:00.0 Network controller [0280]: Intel Corporation PRO/Wireless 5100 AGN [Shil
oh] Network Connection [8086:4237]
        Subsystem: Intel Corporation WiFi Link 5100 AGN [8086:1211]
        Flags: bus master, fast devsel, latency 0, IRQ 51
        Memory at f4200000 (64-bit, non-prefetchable) [size=8K]
        Capabilities: <access denied>
        Kernel driver in use: iwlwifi
```

We now know the device id 8086:4237 and the kernel driver that is already
bound to the device (_iwlwifi_).  If the device is bound to a kernel driver,
and since we can see it is in our case,
we need to unbind the kernel driver before we can bind the device to
uio_pci_generic and use the device in a rump kernel.

To unbind:

```
$ echo '0000:03:00.0' > /sys/bus/pci/drivers/iwlwifi/unbind
```

Then, to bind:

```
$ echo '8086 4237' > /sys/bus/pci/drivers/uio_pci_generic/new_id
$ echo '0000:03:00.0' > /sys/bus/pci/drivers/uio_pci_generic/bind
```

We should see the device bound to uio now:

```
$ ls -l /sys/class/uio/
total 0
lrwxrwxrwx 1 root root 0 Apr 15 12:51 uio0 -> ../../devices/pci0000:00/0000:00:1
c.1/0000:03:00.0/uio/uio0
```

You can dig in sysfs more if you like to see what's there.  In any case,
the device should be accessible from a userspace driver now.


Non-Linux hosts
---------------

TODO