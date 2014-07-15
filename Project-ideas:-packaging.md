The rump architecture allows unmodified userspace code to be built for a variety of target environments ("platforms") and provides a "hypercall interface" through which additional platforms may be relatively easily added. As with any layered architecture, each layer in the rump stack is generally intended to be dependent on lower layers and depended on by higher ones.

## Goal

It would be nice to develop one layer of the rump stack without always having to rebuild all its underlying layers from source. In other words, it would be nice to have packages for components at each layer.

While [pkgsrc/misc/rump](http://pkgsrc.se/misc/rump) has existed since 2009, it does not reflect current thinking on the proliferation of available components or current understanding of the boundaries between them.

As usual, solving the problem has at least two parts:

7. Design: choosing logical boundaries between components
7. Implementation: packaging components along these boundaries in at least one real package system

Trying to prepare packages, then trying to use them, will help us choose the right boundaries. Since pkgsrc shares contributors and interested parties with rump, and is no less cross-platform than rump itself, it's probably a good place to experiment with rump packaging.

## Current thinking

It's likely that the following packages would, to a first approximation, suffice:

7. Sources
7. Tools
7. Userspace headers (for building applications)
7. Rump kernel components
7. Hypercall implementations

## Existing repositories and platforms

* [[Repositories|Repos]]
* [[Platforms]]