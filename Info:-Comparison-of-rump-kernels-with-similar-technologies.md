This page compares rump kernels to other projects and products in the
domain of similar or seemingly similar technologies.  The intent is to
help readers familiar with other projects and products better understand
rump kernels.


General-purpose operating systems (e.g. Linux, *BSD, Windows, ...)
---

A general purpose operating system is the whole kitchen sink and a
bit of the toolshed too: necessary drivers to support applications,
resource sharing and weak isolation between application, support for
multiple users, tools for most purposes, and so forth.

Rump kernels do not provide everything needed to build a general purpose
operating system, only the drivers -- otherwise "rump kernels" would be known
simply as "kernels".  That said, a rump kernel can be used as part of
a general purpose operating system kernel to provide drivers.


Hypervisors a.k.a. virtual machine monitors (Xen, KVM, Hyper-V, ...)
---

Hypervisors provide a virtual hardware-like platform with strong isolation
and resource sharing between guests.  They also provide I/O resources for
the guests, either in form of pass-through or emulated hardware devices,
or as virtual I/O devices.

Rump kernels are not intended to function as hypervisors.


Cloud operating systems (e.g. OSv)
---

Cloud operating systems provide support for running applications as
guests on a hypervisor.  As opposed to running a general purpose OS,
cloud operating systems omit operating system layers already provided
by the hypervisor, e.g. application isolation.  The intent of this
simplication is a software stack with better performance and less bloat.

Rump kernels can be used to build custom cloud operating systems;
a minimal one can be built from scratch in less than a week.  Most
hypervisors are already supported.  Since rump kernels provide the
standard drivers, POSIX system calls handlers and a libc, a good deal
of existing applications will readily run on a custom cloud OS built on
rump kernels.


Language-on-hypervisor (e.g. LING, previously known as Erlang-on-Xen)
---

A variant of cloud operating systems, language runtimes running directly
on hypervisors also aim to avoid the resource-hungry and slow-to-bootstrap
general purpose operating system in the cloud software stack.

Similar to rump kernel uses for constructing cloud OS's, the driver layer of rump kernels
allows supporting language runtimes which would normally require a
general purpose operating system.  Rump kernels provide enough of the
POSIX interfaces for language runtimes to function.  For example, the
LuaJIT interpreter was found to just work on rump kernels running on
top of the Xen hypervisor.


Docker
---

Docker is a method for wrapping up an application into an easy-to-deploy
bundle for the cloud.  When provisioned, the application runs on a
platform emulating a full OS, typically realized by using containers
(a.k.a. OS namespace virtualization).

Rump kernels could be used as the technology enabling application
virtualization under a Docker-like management suite.  Building such
a toolset has not yet been undertaken, to the best of our knowledge.
Unlike Docker, application bundles constructed of rump kernels do not
depend on a full OS installation, and can be shipped as self-contained
megabyte-sized images.  Since a rump kernel image includes less code
than a full OS image, there is also less chance of shipping code with
latent security vulnerabilities.


Driver kits (e.g. DDEKit, lwIP, OSKit, ...)
---

Driver kits provide easy-to-integrate drivers, with the set of drivers
varying per driver kit.  For example, lwIP provides a compact TCP/IP
stack driver.  In some cases, driver kits are constructed by porting
and releasing a snapshot of an upstream OS kernel, and in some cases
the whole kit is written from scratch.

Rump kernels essentially provide a driver kit.  There are qualities
which make rump kernels stand apart from other driver kits:
  * Rump kernels can provide a POSIX and libc interface for applications.
    There is excellent support for running existing applications which
    would traditionally require a full operating system.
  * Rump kernels are available under the BSD license, making them free
    for any use.
  * Rump kernels use the NetBSD anykernel architecture to provide
    unmodified NetBSD kernel drivers instead of porting a snapshot of the
    upstream drivers.  The anykernel approach avoids porting errors and
    gives the user the ability to choose the vintage of the upstream
    drivers.
