This page is divided into following subsections:

* [[Articles|Info:-Publications-and-talks#articles-and-publications]].  If the article was presented, link to video/slides may be included.  All entries in this subsection _must_ have a `[paper]` link.
* [[Talks|Info:-Publications-and-talks#talks]], with links to either the video or slides.  Conference presentations without an accompanying paper go into this subsection.
* [[Theses|Info:-Publications-and-talks#theses]], academic theses featuring rump kernels in some capacity.
* [[Blog posts|Info:-Publications-and-talks#blog-posts]].

When adding new entries, try to remain consistent with the existing entries in the relevant
subsection.  Use reverse chronological sort within subsections.

Articles and publications
-------------------------

- __Rump Kernels: No OS? No Problem!__ [[paper](http://rumpkernel.org/misc/usenix-login-2014/)]
  +  _Antti Kantee, Justin Cormack_
  + USENIX ;login:, October 2014
  + summary of rump kernels, especially from the perspective of rumprun.
- __Rump Device Drivers: Shine On You Kernel Diamond__ [[paper](http://ftp.NetBSD.org/pub/NetBSD/misc/pooka/tmp/rumpdev.pdf), [video](http://www.youtube.com/watch?v=3AJNxa33pzk)]
  + _Antti Kantee_
  + AsiaBSDCon 2010
  +  describes device drivers and USB
- __Fs-utils: File Systems Access Tools for Userland__ [[paper](http://www.ukuug.org/events/eurobsdcon2009/papers/ebc09_fs-utils.pdf)]
  + _Arnaud Ysmal, Antti Kantee_
  + EuroBSDCon 2009
  + fs-utils, an mtools-like utility kit which uses rump kernel file systems as a backend
- __Rump File Systems: Kernel Code Reborn__ [[paper](http://usenix.org/events/usenix09/tech/full_papers/kantee/kantee.pdf), [slides](http://usenix.org/events/usenix09/tech/slides/kantee.pdf)]
  + _Antti Kantee_
  + 2009 USENIX Annual Technical Conference
  + kernel file system code and its uses in userspace
- __Kernel Development in Userspace - The Rump Approach__ [[paper](http://www.bsdcan.org/2009/schedule/attachments/104_rumpdevel.pdf), [slides](http://www.bsdcan.org/2009/schedule/attachments/105_bsdcan09-kantee.pdf)]
  + _Antti Kantee_
  + BSDCan 2009
  + kernel development with rump kernels
- __Environmental Independence: BSD Kernel TCP/IP in Userspace__ [[paper](http://2009.asiabsdcon.org/papers/abc2009-P5A-paper.pdf), [video](http://www.youtube.com/watch?v=RxFctq8A0WI)]
  + _Antti Kantee_
  + AsiaBSDCon 2009
  + networking with rump kernels

Talks
-----

- __Rumprun for Rump Kernels: Instant Unikernels for POSIX applications__ [[slides](http://operatingsystems.io/slides/rumprun-rump-kernels-lucina.pdf)]
  + _Martin Lucina_
  + New Directions in Operating Systems, 2014
  + demonstrates the rumprun tool for deploying Rump Kernels as Unikernels on Xen
- __Rump kernels and {why,how} we got here__ [[video](https://www.youtube.com/watch?v=GoB73cVyScI), [slides](http://operatingsystems.io/slides/rumpkernel.pdf)]
  + _Antti Kantee_
  + overview and history
  + New Directions in Operating Systems, 2014
- __Running Applications on the NetBSD Rump Kernel__ [[video](https://va.ludost.net/files/eurobsdcon/2014/Pirin/03.Saturday/02.Running%20Applications%20on%20the%20NetBSD%20Rump%20Kernel%20-%20Justin%20Cormack.mp4), [slides](http://eurobsdcon.myriabit.eu/)]
  + _Justin Cormack_
  + new developments and running applications
  + EuroBSDCon 2014
- __Rump Kernels, Just Components__ [[video](http://video.fosdem.org/2014/H2214/Sunday/Rump_Kernels_Just_Components.webm), [slides](https://fosdem.org/2014/schedule/event/01_uk_rump_kernels/attachments/slides/398/export/events/attachments/01_uk_rump_kernels/slides/398/fosdem2014.pdf)]
  + _Antti Kantee_
  + rump kernels as reusable and platform-agnostic drivers; targets a developer audience
  + FOSDEM 2014 Microkernel devroom
- __The Anykernel and Rump Kernels__ [[video](http://video.fosdem.org/2013/maintracks/K.1.105/The_Anykernel_and_Rump_Kernels.webm), [slides](https://fosdem.org/2013/schedule/event/operating_systems_anykernel/attachments/slides/244/export/events/attachments/operating_systems_anykernel/slides/244/fosdem2013_rumpkern.pdf), [interview](https://archive.fosdem.org/2013/interviews/2013-antii-kantee/)]
  + _Antti Kantee_
  + FOSDEM 2013 Operating Systems track
  + general overview, demonstrates rump kernels running on Windows and in Firefox

Theses
------
- __User space approach to audio device driving on UNIX-like systems__ [[pdf](http://upcommons.upc.edu/pfc/bitstream/2099.1/25316/1/104462.pdf)]
  + _Robert Millan_
  + Universitat Politècnica de Catalunya, 2015
- __A Split TCP/IP Stack Implementation for GNU/Linux__ [[pdf](http://os.inf.tu-dresden.de/papers_ps/unzner-diplom.pdf)]
  + _Martin Unzner_
  + TU Dresden, 2014
- __The Design and Implementation of the Anykernel and Rump Kernels__ [[pdf](http://lib.tkk.fi/Diss/2012/isbn9789526049175/isbn9789526049175.pdf)]
  + _Antti Kantee_
  + Aalto University, 2012.

Blog posts
----------

-   [An Internet-Ready OS From Scratch in a Week — Rump Kernels on Bare
    Metal](http://blog.netbsd.org/tnf/entry/an_internet_ready_os_from) (NetBSD blog, 2014)
-   [Running rump kernels and applications on Xen without a full
    OS](http://blog.NetBSD.org/tnf/entry/running_applications_on_the_xen) (NetBSD blog, 2013)
-   [PCI device driver support in rump kernels on
    Xen](http://blog.NetBSD.org/tnf/entry/pci_driver_support_for_rump) (NetBSD blog, 2013)
-   [Experiment with a rump kernel hypervisor for the Linux
    kernel](http://blog.NetBSD.org/tnf/entry/a_rump_kernel_hypervisor_for)
    which allows rump kernels to run *in* the Linux kernel (NetBSD blog, 2013)
-   [Experiment on compiling rump kernels to javascript and running them
    in the
    browser](http://blog.NetBSD.org/tnf/entry/kernel_drivers_compiled_to_javascript) (NetBSD blog, 2012)
-   [Kernel Servers using
    Rump [Kernels]](http://www.NetBSD.org/docs/rump/sysproxy.html) (NetBSD website, 2011)
-   [Tutorial On Rump Kernel Servers and
    Clients](http://www.NetBSD.org/docs/rump/sptut.html) (NetBSD website, 2011)
-   [Revolutionizing Kernel Development: Testing With
    Rump [Kernels]](http://blog.NetBSD.org/tnf/entry/revolutionizing_kernel_development_testing_with) (NetBSD blog, 2010)
