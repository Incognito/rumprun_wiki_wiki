## Foreword

The purpose of this exercise is to lay groundwork for the performance
optimization of the NetBSD TCP/IP stack running in a rump kernel in
userspace.  While a rump kernel always runs directly on host threads,
synchronization constructs within the rump kernel limit which host
thread can run.  To understand how to optimize the host's scheduling, we need
to understand what is happening.

For packet generation, we will use
[rump-pktgenif](http://repo.rumpkernel.org/rump-pktgenif).
For tracing, we will use [LTTng](http://lttng.org), and will run the
rump kernel in userspace on Linux.


## Getting LTTng

The sane procedure for this will vary depending on what your system is
running, and will not be exhaustively documented here.  I was running
on Ubuntu, and did not have huge success with the LTTng 2.1 offered in
Ubuntu 13.10.  After switching to LTTng 2.4.0 offered by an Ubuntu PPA,
as detailed [here](https://launchpad.net/~lttng/+archive/ppa), the rate
of success grew.  Your mileage may vary.


## Compiling rump-pktgenif

As a prerequisite, you need
[buildrump.sh](http://repo.rumpkernel.org/buildrump.sh).
The latest version is recommended.

To fetch and build, simply run:

        git clone http://repo.rumpkernel.org/rump-pktgenif
        cd rump-pktgenif
        rumpmake USE_LTTNG=1 dependall

(see buildrump.sh for more information on how to find `rumpmake`
and place it in your `$PATH`)

Building with `USE_LTTNG=1` will add lttng-ust probes into the code,
making it easier to track kernel events.


## Running rump-pktgenif

For the packet generator to be able to run, you must configure the TCP/IP
stack that it is using (cf. `ifconfig` etc.).  The easiest way to do this is
to use [[rumpctrl|Repo:-rumpctrl]].  Edit the path
at the top of `config.sh.example` to point to your rumpctrl directory,
and you are good to go.

Run the tool with for example:

        ./testtool -r ./<configname> recv

Press ctrl-c to end the run.


## Capturing a trace

We will capture a basic trace which includes context switches, cache
misses, and the pktgenif tool specified tracepoints.  You are of
course free to adjust this list however you want.  Run the commands
with appropriate privileges (root or being in the group "tracing" was
enough for me, but consult LTTng documentation to be sure).

        lttng create testtool
        lttng enable-event -k sched_switch
        lttng add-context -k -t perf:cache-misses
        lttng enable-event -u 'pktgenif:*'

Now, run the packet generator in another window and then type:

        lttng start ; sleep 1 ; lttng stop

The packet generator can be stopped now.  You can view the raw capture
data with `lttng view`.  A visualization tool is helpful in getting
a better idea of what is going on.


## Visualizing the trace

If you have Eclipse, you can try using the LTTng plugin.  I did not
have Eclipse and did not have good luck installing it and the plugin,
so I used the standalone version available from [this
page](http://lttng.org/eclipse).

To view the trace:

* `File -> Import`, enter the path that `lttng create` printed
* click the checkpoint next to the box, click `Finish`
* open the `Traces` tree on the left-hand side
* right-click the items (`64-bit` and `kernel` for me), select `Open` for both

You should now have the event information and the scheduling information
on the screen.  To make the scheduling information a bit more palatable,
restrict threads only to the ones we are interested in.  On the top right,
click `Show View Filters`, click `Uncheck All`, then select anything the
the name `testtool`, `pktgen` and `rsi?/3`.  The number of `rsi?` depends
on the number of cores configured into the rump kernel (default: 2).
Notably, everything we selected is in a single process.  If someone knows
an easier way of selecting threads in a single process, please edit the above.

You should see something like: ![lttng pktgenif](https://raw.githubusercontent.com/rumpkernel/wiki/master/img/lttng-pktgenif.png) 

## Finished

Run `lttng destroy` to remove your session.
