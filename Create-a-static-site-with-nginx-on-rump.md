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

So all we need to do right now is run make:

    make

And that's created the unikernel into `./bin/nginx`. We're almost ready, all that's left is to "bake" the image. Lets see what platforms you can bake for by using the command:

    rumpbake list

You will probably see `hw_generic` which is a suitable option for our purposes. Now we bake the unikernel into a bootable unikernel called "nginx.bin" (you can pick any name really):

    rumpbake hw_generic nginx.bin bin/nginx

Lastly, we will boot the image and provide the config files by using QEMU (make sure it is installed) by running this command:

    rumprun qemu -M 128 -i \
        -n inet,static,10.10.10.10/24 \
        -b images/stubetc.iso,/etc \
        -b images/data.iso,/data \
        -- nginx.bin -c /data/conf/nginx.conf

You should see QEMU launch, some debugging text scroll by, and finally end without any messages about "panic". If you see "panic" it means something is broken.

// TODO add an image of what a good qemu window looks like.

# 3. Connecting to qemu

...TODO...

-tun/tap https://github.com/rumpkernel/wiki/wiki/Howto%3A-Networking-with-if_virt

# 4. Putting our static site into rump-nginx.

...TODO...
