This page documents the host commands necessary to access the host's networking from a rump kernel.  You should use them only as rough guides and replace the interface numbers with ones relevant for your setup.  The examples here will allow your rump kernel's `virt0` to send and receive packets via the host's `eth0`.

## Linux

This was tested on [Void Linux](http://voidlinux.eu).  Details may vary on your distribution.  Note that unlike on BSD systems, this will affect the host's IP stack too, since traffic will now be routed through the bridge interface instead of `eth0`.  Exercise caution if you want to execute these commands remotely.

* `dhcpcd -k`
* `ip addr flush eth0`
* `ip tuntap add tun0 mode tap`
* `ip link set dev tun0 up`
* `brctl addbr br0`
* `brctl addif br0 eth0 tun0`
* `dhcpcd -n`

If you now run `ip addr show`, you should now see your host's IP address on `br0` instead of `eth0`.

In case anyone knows how to make bridging the tap interface in Linux more like how it works on a BSD system (i.e. host IP stack is _not_ affected), please let me know!

#### Linux - Ubuntu 12.04
The following instructions were tested on Ubuntu 12.04

* `ip tuntap add tun0 mode tap`
* `ip link set dev tun0 up`
* `brctl addbr br0`
* `brctl addif br0 eth0 tun0`
* `ifconfig eth0 0.0.0.0`
* `ifconfig br0 up`
* `dhclient br0`

### Troubleshooting on Linux

Your kernel might have ethernet filtering (ebtables, bridge-nf, arptables) enabled, and traffic gets filtered. The easiest way to disable this is to go to /proc/sys/net/bridge. Check if the bridge-nf-* entries in there are set to 1; in that case, set them to zero and try again.

* `cd /proc/sys/net/bridge`
* `for f in bridge-nf-*; do echo 0 > $f; done`


## DragonFly BSD

DragonFly is almost the same as NetBSD.  The difference is that there is no brconfig(8) and ifconfig(8) is used for that purpose.

* `ifconfig tap0 create`
* `ifconfig tap0 up`
* `ifconfig bridge0 create`
* `ifconfig bridge0 addm eth0 addm tap0`
* `ifconfig bridge0 up`