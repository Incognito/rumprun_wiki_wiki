We demonstrate configuring NetBSD's [npf](http://man.NetBSD.org/cgi-bin/man-cgi?npf++NetBSD-current) packet filter using rumprun.  For this demonstration, we use a very simple npf configuration file and two networking stacks connected by [shmif](http://man.NetBSD.org/cgi-bin/man-cgi?shmif++NetBSD-current).  The configuration can be extended to arbitrarily complex scenarios supported by npf, and also other network interfaces.

You will need a [rumprun](http://repo.rumpkernel.org/rumprun) installation.  Familiarize yourself with rumprun before attempting to follow the rest of this howto, and set the relevant environment variables.

First, we run two rump kernels.  Note that the first one does not support a packet filter (it does not need one for this demonstration).  Also note that the rump kernel with npf requires VFS so that the `npfctl` can read the configuration file we supply to it.

```
$ rump_server -lrumpnet_shmif -lrumpnet_netinet -lrumpnet_net -lrumpnet unix:///tmp/net1
$ rump_server -lrumpnet_shmif -lrumpnet_netinet -lrumpnet_net -lrumpnet -lrumpnet_npf -lrumpdev_bpf -lrumpdev -lrumpvfs unix:///tmp/net2
```

If you do not otherwise have a `rump_server` handy, you can find one from `rumpdyn/bin` after building rumprun.

Configure the shmif interface for both networking stacks, and attach them to each other. We assume that you do this from your rumprun directory, adjust the path for the rumprun binaries otherwise:

```
$ export RUMP_SERVER=unix:///tmp/net1
$ ./bin/ifconfig shmif0 create
$ ./bin/ifconfig shmif0 linkstr /tmp/busmem
$ ./bin/ifconfig shmif0 inet 1.2.3.1

$ export RUMP_SERVER=unix:///tmp/net2
$ ./bin/ifconfig shmif0 create
$ ./bin/ifconfig shmif0 linkstr /tmp/busmem
$ ./bin/ifconfig shmif0 inet 1.2.3.2
```

From now on, we will assume that we are operating on the latter rump kernel, i.e. `$RUMP_SERVER` remains to be set at `unix:///tmp/net2`.

Let's test that we can ping the first stack from the second:

```
$ ./bin/ping -c 1 1.2.3.1
PING 1.2.3.1 (1.2.3.1): 64 data bytes
64 bytes from 1.2.3.1: icmp_seq=0 ttl=255 time=1.710695 ms

----1.2.3.1 PING Statistics----
1 packets transmitted, 1 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 1.710695/1.710695/1.710695/0.000000 ms
```

Now, while still accessing the second rump kernel (net2), create a npf.conf and load it.  Alternatively, one could use an npf.conf from the host and expose it to the rump kernel using the `-d` parameter to the rump kernel.  However, here we just use `dd` to create one:

```
$ ./bin/dd of=/npf.conf
group default {
        ruleset "test-set"
        pass all
}
0+4 records in
0+1 records out
62 bytes transferred in 6.428 secs (9 bytes/sec)
```

Now, we can load the configuration file and create a dynamic rule for "test-set" blocking ICMP with our peer:

```
$ ./bin/npfctl reload /npf.conf
$ ./bin/npfctl rule "test-set" add block proto icmp from 1.2.3.1
OK 1
$ ./bin/npfctl show
Filtering:	inactive
Configuration:	loaded

group 
	ruleset "test-set" all 
	pass all 
```

Finally, test that we can ping, activate npf, test that we can't ping, disable npf, and test that we can ping again:

```
$ ./bin/ping -oq 1.2.3.1
PING 1.2.3.1 (1.2.3.1): 64 data bytes

----1.2.3.1 PING Statistics----
1 packets transmitted, 1 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 1.377549/1.377549/1.377549/0.000000 ms
$ ./bin/npfctl start
$ ./bin/ping -oq -w 2 1.2.3.1
PING 1.2.3.1 (1.2.3.1): 64 data bytes

----1.2.3.1 PING Statistics----
2 packets transmitted, 0 packets received, 100.0% packet loss
$ ./bin/npfctl stop
$ ./bin/ping -oq -w 2 1.2.3.1
PING 1.2.3.1 (1.2.3.1): 64 data bytes

----1.2.3.1 PING Statistics----
1 packets transmitted, 1 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 1.615149/1.615149/1.615149/0.000000 ms
```

Success.