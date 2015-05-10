This page contains links to various binary packages, or instructions on how
to install the binary packages.

Userspace rump kernel components
--------------------------------

* Void Linux: `xbps-install -S netbsd-rumpkernel`
* Arch Linux: [pacman](https://build.opensuse.org/package/binaries/home:staal1978/rump?repository=Arch_Extra) (OBS), [AUR](https://aur.archlinux.org/packages/netbsd-rump-git/) 
* OpenSUSE Linux:
Tumbleweed [RPM](https://build.opensuse.org/package/binaries/home:staal1978/rump?repository=openSUSE_Factory) (OBS)
|| Factory [RPM](https://build.opensuse.org/package/binaries/home:staal1978/rump?repository=openSUSE_Factory) (OBS)
|| SLE_11_SP2 [RPM](https://build.opensuse.org/package/binaries/home:staal1978/rump?repository=SLE_11_SP2) (OBS)
* Fedora Linux:
Fedora 21 [RPM](https://build.opensuse.org/package/binaries/home:staal1978/rump?repository=Fedora_21) (OBS) || RHEL 6 [RPM](https://build.opensuse.org/package/binaries/home:staal1978/rump?repository=RedHat_RHEL-6) (OBS) || RHEL 7 [RPM](https://build.opensuse.org/package/binaries/home:staal1978/rump?repository=RHEL_7) (OBS) 
|| CentOS 6 [RPM](https://build.opensuse.org/package/binaries/home:staal1978/rump?repository=CentOS_CentOS-6) (OBS) || CentOS 7 [RPM](https://build.opensuse.org/package/binaries/home:staal1978/rump?repository=CentOS_7) (OBS)
* Debian Linux:
7 [DEB](https://build.opensuse.org/package/binaries/home:staal1978/rump?repository=Debian_7.0) (OBS) || 8 [DEB](https://build.opensuse.org/package/binaries/home:staal1978/rump?repository=Debian_8.0) (OBS)
* Ubuntu Linux:
15.04 [DEB](https://build.opensuse.org/package/binaries/home:staal1978/rump?repository=xUbuntu_15.04) (OBS)
* NetBSD: pkgsrc/misc/rump
* DragonFly BSD: pkgsrc/misc/rump
* Solaris: pkgsrc/misc/rump

The links for some of packages are provided by the
[openSUSE Build Service](https://build.opensuse.org/package/show?package=rump&project=home%3Astaal1978). 
You can download and install the packages manually, but it is highly recommended to add the OBS repositories for the right distro and architecture to the package manager. This way, updates and dependencies will be automatically resolved for other packages depending on rump kernels.