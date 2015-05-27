The [hardware (``hw'') platform](http://repo.rumpkernel.org/rumprun) runs both
on top of actual hardware as on top of various virtual machine hypervisors.
It supports both virtio drivers and hardware drivers.

Since the platform runs on top of bare metal, the bootstrap procedures
and low-level bootstrap is machine dependent.  However, since barely
any code is required, platform support can be written in an afternoon
by someone familiar with the target platform.
