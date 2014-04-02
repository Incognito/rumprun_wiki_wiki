It is possible to run netperf on the Rump kernel. I have modified the netserver part to work with Rump, while netperf itself is supposed to run on the default network stack. For installation instructions, please check out the `README.md` of the netserver repository: https://github.com/Logout22/netserver

If you like, you can also check out the master branch, which is designed to work with my main project Swarm (included in my buildrump fork: https://github.com/Logout22/buildrump.sh). Instead of starting a DHCP server, start Swarm before running netserver. You might experience slightly better performance there.

Swarm is a research project, and I admit it is poorly documented. If you are missing information, or if you are having trouble, please contact me via email: abmelden22 (-) gmx.de