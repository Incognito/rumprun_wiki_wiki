This page is focused on giving application and web developers the steps and knowledge to get running with a basic Rump Unikernel. This assumes you are familiar with at least one programming language, basic command line scripts, and the Command Line Interface (not the one in windows).

# What is a Rump Kernel?

A Rump Kernel lets you run an application without the bloat of an operating system by only providing device drivers (so your application can interact with things like the network), but none of the things you would expect from an OS like users, running multiple applications, or things like that. This lets you boot a virtualized or bare-metal application in a fraction of the time and removes a large set of security concerns unrelated to your application. Think of it as a more minimalist analog to something like Docker.

# What we will be doing

1. Getting the "Rumprun" toolchain to build rump kernels
2. Getting the rump-nginx to build and launch on qemu
3. Connecting to qemu
4. Putting our static site into rump-nginx.

Note: This is all experimental and you may need to tweak some scripts. There will be an explanation of the tools in enough detail that you will have a better chance at figuring out how to fix things if something goes wrong. If you're really stuck please join the #rumpkernel discussion at http://webchat.freenode.net/ .

# 1. Getting "Rumprun"

This repo is responsible for providing all the tools someone who develops with rump would need. There are debugging scripts for the kernels, and compiler tools to help build kernels. It also includes NetBSD drivers as a dependency. We only need to worry about building this and using the tools it provides.

First we'll need to download the repository and its dependencies:

    git clone https://github.com/rumpkernel/rumprun.git
    cd rumprun
    git submodule update --init

Now that all the source code is checked out you will need to compile it. Depending on your distro you will need to ensure you have GCC (A C compiler) installed. Rumprun does not yet support Clang (a different compiler) and you may find issues if you try to use it.

There are two options we can pick to build the toolchain for, either "hw" (hardware) or "xen" (a specific open source hyperviser). For us, we'll pick "hw" as this is the easiest tool to get started with (unless you already have a Xen Dom0 host you have access to). Even though we're building for hardware, remember, we can use a virtual machine for running this, so there's no need to dust off a second machine somewhere to try it on (although, it would work just fine).

Lucky us, everything needed to do a build is provided in a simple script, so we simply run the command:

    ./build-rr hw

This will take a while as you are compiling both C and C++ code (you should see a lot of text streaming by your terminal). Once you are done (you will know because it says "build-rr ran successfully") you must add the path of app-tools to your user path. This can be done quickly by typing this in (if you use Bash):

    export PATH=/path/to/rumprun/app-tools:$PATH

Now that you have appended the directory where all your new tools are to your $PATH variable you can call those scripts from any directory. If you close the window you may lose this assignment. If you use a different terminal window do not expect to have this value assigned. [You can read more about $PATH here](http://stackoverflow.com/questions/7510249/path-environment-variable-in-linux).

## If you run into problems compiling...

Read the errors and try to make sense of them. There is either an error with the code, or the way the parser reads the code. You can optionally disable C or C++ from building but you won't have a fully working toolchain (one of these will be missing). Do report the bug to where it belongs (either the GCC project, NetBSD, or Rump) so that it can be fixed.

# 2. Getting the rump-nginx to build and launch on qemu

Now that you have the toolchain installed, lets find a Rump unikernel that fits our needs. Lucky for us, one that builds Nginx already exists! You'll want to download that project into a new directory.

    git clone https://github.com/mato/rump-nginx.git
    cd rump-nginx

If you look inside your app-tools path you will see you have various executable available to you, one will be called something like "rumprun-arch-cc" where "arch" is replaced by something meaningful about the architecture you are compiling for.

You will need to install a program called `genisoimage` onto your system to build an ISO file which can be used to load the image onto bare metal. If you're having a hard time finding the package: `genisoimage` is included in a package called `cdrkit` on many systems.

So all we need to do right now is run make, and point the C compiler to the version we just made with the toolchain:

    RUMPRUN_CC=rumprun-bmk-cc make

And that's created the Nginx part of the unikernel into `./bin/nginx`. We're almost ready, all that's left is to "bake" the image. Lets see what platforms you can bake for by using the command:

    rumpbake list 

You will probably see `hw_generic` which is a suitable option for our purposes. Now we bake the unikernel into a bootable unikernel called "nginx.bin" (you can pick any name really):

    rumpbake hw_generic ./nginx.bin bin/nginx

Lastly, we will boot the image and provide the config files by using QEMU (make sure it is installed) by running this command:

```
    rumprun qemu -M 128 -i \
        -n inet,static,10.10.10.10/24 \
        -b images/stubetc.iso,/etc \
        -b images/data.iso,/data \
        -- nginx.bin -c /data/conf/nginx.conf
```

You should see QEMU launch, some debugging text scroll by, and finally end without any messages about "panic". If you see "panic" it means something is broken. You should expect to see something like "rumprun: call to sigaction ignored" which is fine. Rump has a different understanding of signals than you would expect on an operating system.

![QEMU if everything built correctly.](http://imgur.com/czS3ei1l.png)

You can kill the window if everything looks good, and we'll go on to set up your networking correctly.

# 3. Connecting to QEMU

Congratulations on launching a working Rump unikernel! Now we need to launch it on a network and configure your host machine so you can sent HTTP requests to it.

There are a few options here. QEMU does support port forwarding, but you may not find that useful for long lived or larger applications with complicated needs, so lets look into using [http://backreference.org/2010/03/26/tuntap-interface-tutorial/](Tun/Tap) (a purely software virtual network device).

Lets tell our system we now have a tap device named "tun0", give it a network (not the same as one that you are connected to already), and turn it on (you may need to be root or use sudo).

    ip tuntap add tun0 mode tap
    ip addr add 10.0.120.100/24 dev tun0
    ip link set dev tun0 up

Now if you run the command `ip addr` you should expect to see a network device called "tun0" along with your other network devices (wireless, ethernet, etc).

You want to pick a network that is not your own. So if your host machine's IP address is `192.168.1.20` you can pick `10.10.10.10` (or anything else, so long as it's one of those private )

You can test that you created the device if you can ping it: `ping 10.0.120.100`.

Finally, we can launch our Nginx Rump Unikernel on that network :)

The following command will do these things in this order:

1. Run QEMU as the emulator for the image
2. (-i) Attach the guest console on startup
3. (-M) Set the memory limit to 128 megabytes
4. (-I) Create the guest network interface and attach an "iftag" to it.
5. (-W) Configure the network interface for the VM's address (pick an IP on your TUN network with a different address than you used for the Tun0 interface)
6. (-b) mount data.iso as a block device on /data of the unikernel
7. (-b) mount subetc.iso as a block device on /etc of the unikernel
8. (--) start nginx and tell it where the config file lives.

```
    rumprun qemu -i -M 128 \
        -I if,vioif,'-net tap,script=no,ifname=tun0'\
        -W if,inet,static,10.0.120.101/24 \
        -b images/data.iso,/data \
        -b images/stubetc.iso,/etc \
        -- ./nginx.bin -c /data/conf/nginx.conf
```

[ There is a related guide for more ways to configure tun and tap for use with Rump.](https://github.com/rumpkernel/wiki/wiki/Howto%3A-Networking-with-if_virt)

If everything works, you should be able to visit the IP address you provided to rumprun and see it working:

![Running nginx on your tun network](http://imgur.com/eJS2Uqkl.png)

Feel free to kill your QEMU when you're done.

# 4. Putting our static site into rump-nginx.

The files used in rump-nginx for the static site are in `./images/data/www` (and the config files for nginx are in `./images/data/conf`). Simply replace www's files with what you would like. If you're looking for a static site generator many great options exist such as [Sculpin](https://sculpin.io/) or [Jekyll](http://jekyllrb.com/).

Now all you need to do is run the make, rumpbake, and rumprun commands from step 2 to rebuild your unikernel with the updated content.

If you have issues reconnecting, double check that you haven't lost your tun0 device when you killed your emulator. It may have lost its IP address or gone into a "down" state. 

