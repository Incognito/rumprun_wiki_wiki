Though a rump kernel does not require a root file system image, some
applications and library routines expect to be able to access files.
For example, the `getservent()` call searches `/etc/services`, and
a web server serving static content typically serves it from a file
system hierarchy.  To satisfy these demands, we mount file systems in
the rump kernel file system namespace.  Any file system type, e.g. NFS,
would do, but it's usually simplest mount a prepopulated image.

## rumprun/xen

For rumprun/xen, we supply prepopulated images in
http://repo.rumpkernel.org/rumprun/tree/master/platform/xen/img.
The same images can be applied to other "standalone" scenarios as well.
If your host does not support FFS, you can still examine and modify the
images using the portable [fs-utils](https://github.com/stacktic/fs-utils)
tool suite.
