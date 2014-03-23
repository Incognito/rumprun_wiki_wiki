Using ipv6 networking with a rump kernel is very simple, especially if you are in an environemnt with router advertisements.

First create a rump server as usual (paths relative to rumprun directory, adjust as needed). You need to do this as root or with appropriate permissions as it needs to create a network device.

```
./rumpdyn/bin/rump_allserver unix://sock
export RUMP_SERVER=unix://sock
```

Now create the virtif
```
./bin/ifconfig virt0 create
./bin/ifconfig virt0 up
./bin/ifconfig virt0
virt0: flags=8843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST> mtu 1500
	address: b2:0a:45:0b:0e:00
	inet6 fe80::b00a:45ff:fe0b:e00%virt0 prefixlen 64 scopeid 0x2
```

This will create the tap device tun0 or tap0 (Linux is currently tun0). Add to a bridge as described on [[Howto:-Networking-with-if_virt]], eg as below. You can do this before or after creating the virt device - if you use the method on that page and create it first you will get a persistent device, otherwise it will go away when the rump server closes.

```
ifconfig tun0 up
brctl addif br0 tun0
```

Now turn on ipv6 autoconfiguration:
```
./bin/sysctl -w net.inet6.ip6.accept_rtadv=1
./bin/ifconfig virt0
virt0: flags=8843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST> mtu 1500
	address: b2:0a:0c:0b:0e:01
	inet6 fe80::b00a:cff:fe0b:e01%virt1 prefixlen 64 scopeid 0x2
	inet6 2a01:4f8:202:302c:b00a:cff:fe0b:e01 prefixlen 64
./bin/ping6 -c 1 2001:4860:4860::8888
PING6(56=40+8+8 bytes) 2a01:4f8:202:302c:b00a:cff:fe0b:e01 --> 2001:4860:4860::8888
16 bytes from 2001:4860:4860::8888, icmp_seq=0 hlim=54 time=10.000 ms

--- 2001:4860:4860::8888 ping6 statistics ---
1 packets transmitted, 1 packets received, 0.0% packet loss
round-trip min/avg/max/std-dev = 10.000/10.000/10.000/0.000 ms
```

You have connectivity!


