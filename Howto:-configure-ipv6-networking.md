Using IPv6 networking with a rump kernel is very simple, especially if you are in an environment with router advertisements.

We assume you have a rump kernel running and listening to remote commands
at `unix://sock`.  We will use [[rumpctrl|Repo:-rumpctrl]] to issue the
necessary commands.

```
$ . rumpctrl.sh -u sock
```

If you already have an interface that is attached to the network, you
can skip ahead to "Activating IPv6 autoconfiguration".  If not, and
want to create a _virt_ interface and attach it to the host network,
follow the steps below.

```
rumpctrl (unix://sock)$ ifconfig virt0 create
rumpctrl (unix://sock)$ ifconfig virt0 up
rumpctrl (unix://sock)$ ifconfig virt0
virt0: flags=8843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST> mtu 1500
	address: b2:0a:8c:0b:0e:00
	inet6 fe80::b00a:8cff:fe0b:e00%virt0 prefixlen 64 scopeid 0x2
```

This will create the tap device tun0 or tap0 (Linux is currently
tun0). Add to a bridge as described on [[Howto:-Networking-with-if_virt]],
e.g. as below. You can do this before or after creating the virt device --
if you use the method on that page and create it first you will get a
persistent device, otherwise it will go away when the rump server closes.

```
# ifconfig tun0 up
# brctl addif br0 tun0
```

Activating IPv6 autoconfiguration
---------------------------------

```
rumpctrl (unix://sock)$ sysctl -w net.inet6.ip6.accept_rtadv=1
net.inet6.ip6.accept_rtadv: 0 -> 1
rumpctrl (unix://sock)$ ifconfig virt0
virt0: flags=8843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST> mtu 1500
	address: b2:0a:0c:0b:0e:01
	inet6 fe80::b00a:cff:fe0b:e01%virt1 prefixlen 64 scopeid 0x2
	inet6 2a01:4f8:202:302c:b00a:cff:fe0b:e01 prefixlen 64
rumpctrl (unix://sock)$ ping6 -c 1 2001:4860:4860::8888
PING6(56=40+8+8 bytes) 2a01:4f8:202:302c:b00a:cff:fe0b:e01 --> 2001:4860:4860::8888
16 bytes from 2001:4860:4860::8888, icmp_seq=0 hlim=54 time=10.000 ms

--- 2001:4860:4860::8888 ping6 statistics ---
1 packets transmitted, 1 packets received, 0.0% packet loss
round-trip min/avg/max/std-dev = 10.000/10.000/10.000/0.000 ms
```

You have connectivity!
