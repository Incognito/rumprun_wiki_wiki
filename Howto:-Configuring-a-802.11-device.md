The aim of this howto is show how to configure an IEEE802.11 wireless PCI device in a userspace rump kernel
using [[rumpctrl|Repo:-rumpctrl]].  This howto builds up on many other components, so in case you have no
prior experience with rump kernels, some amount of patience will be required to successfully follow
the howto.

We will assume that the target network uses WPA.  We will also assumed that you have already
followed the instructions for setting up userspace PCI device drivers and built the necessary
components (see [[here|Repo:-pci-userspace-linux]]). Finally, we assume that you have rumpctrl available.

Let's assume you have a rump kernel server already running with the necessary components
loaded.  If not, see the self-contained example in http://repo.rumpkernel.org/pci-userspace-linux/tree/master/examples/if_iwn -- you could also use `rump_server`, but using a self-contained C program may be
easier to handle.

In any case, let's assume your kernel server is running, and you've started your rumpctrl session.
Attaching the 802.11 NIC to a WPA-protected network follows almost exactly the same procedure
as on a standard NetBSD host.  First, we start by examining the interface:

```
rumpctrl (unix:///tmp/iwnsock)$ ifconfig iwn0
iwn0: flags=8802<BROADCAST,SIMPLEX,MULTICAST> mtu 1500
        ssid ""
        powersave off
        address: XX:XX:XX:XX:XX:XX
        media: IEEE802.11 autoselect
        status: no network
rumpctrl (unix:///tmp/iwnsock)$ ifconfig iwn0 up
rumpctrl (unix:///tmp/iwnsock)$ wlanctl iwn0 | grep rates
        rates *1.0 *2.0 *5.5 6.0 9.0 *11.0 12.0 18.0 24.0 36.0 48.0 [54.0]
        rates *1.0 *2.0 *5.5 6.0 9.0 *11.0 12.0 18.0 24.0 36.0 48.0 [54.0]
        rates *1.0 *2.0 *5.5 6.0 9.0 *11.0 12.0 18.0 24.0 36.0 48.0 [54.0]
        rates *1.0 *2.0 *5.5 6.0 9.0 *11.0 12.0 18.0 24.0 36.0 48.0 [54.0]
        rates *1.0 *2.0 *5.5 6.0 9.0 *11.0 12.0 18.0 24.0 36.0 48.0 [54.0]
        rates *1.0 *2.0 *5.5 [*11.0]
        rates *1.0 *2.0 *5.5 6.0 9.0 *11.0 12.0 18.0 24.0 36.0 48.0 [54.0]
        rates *1.0 *2.0 *5.5 6.0 9.0 *11.0 12.0 18.0 24.0 36.0 48.0 [54.0]
        rates *1.0 *2.0 *5.5 6.0 9.0 *11.0 12.0 18.0 24.0 36.0 48.0 [54.0]
        rates *1.0 *2.0 *5.5 6.0 9.0 *11.0 12.0 18.0 24.0 36.0 48.0 [54.0]
        rates *6.0 9.0 *12.0 18.0 *24.0 36.0 48.0 [54.0]
        rates 1.0 2.0 5.5 11.0 6.0 9.0 12.0 18.0 24.0 36.0 48.0 [54.0]
```

(bear with me, I'm trying to list some `wlanctl` output that doesn't
contain any unique identifiers ;)

Now, we need a configuration file for `wpa_supplicant`.  Assuming you do
not have one handy, it can be created with `wpa_passphrase`.

```
rumpctrl (unix:///tmp/iwnsock)$ wpa_passphrase it-is-a-secret unbleedablepw | dd of=/wpa.conf
0+3 records in
0+1 records out
127 bytes transferred in 0.020 secs (6350 bytes/sec)
rumpctrl (unix:///tmp/iwnsock)$ cat /wpa.conf
network={
	ssid="it-is-a-secret"
	#psk="unbleedablepw"
	psk=c49c8f0dad52f892eb0c797ab7003071c659d4a188ade76a739105408c578d6f
}
```

Yes, in case you're wondering, the pipe to `dd` instead of a shell redirect was how the configuration
procedure differs from standard NetBSD.

The only remaining step is to run `wpa_supplicant` and examine the results.

```
rumpctrl (unix:///tmp/iwnsock)$ wpa_supplicant -i iwn0 -c /wpa.conf
Successfully initialized wpa_supplicant
iwn0: Trying to associate with XX:XX:XX:XX:XX:XX (SSID='it-is-a-secret' freq=2412 MHz)
iwn0: Associated with XX:XX:XX:XX:XX:XX
iwn0: WPA: Key negotiation completed with XX:XX:XX:XX:XX:XX [PTK=CCMP GTK=TKIP]
iwn0: CTRL-EVENT-CONNECTED - Connection to XX:XX:XX:XX:XX:XX completed [id=0 id_str=]
rumpctrl (unix:///tmp/iwnsock)$ ifconfig iwn0
iwn0: flags=8843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST> mtu 1500
        ssid [redacted]
        powersave off
        bssid XX:XX:XX:XX:XX:XX chan 1
        address: XX:XX:XX:XX:XX:XX
        media: IEEE802.11 autoselect (DS1 mode 11g)
        status: active
        inet6 fe80::XXX:XXff:feXX:XXXX%iwn0 prefixlen 64 scopeid 0x2
```

(that's a lot of MAC addressy and other uniquely identifying stuff to
blank out! ;)

Then, you can proceed to use rumpctrl to configure IP level networking.
For example IPv6 networking is covered [[here|Howto:-configure-ipv6-networking]].
