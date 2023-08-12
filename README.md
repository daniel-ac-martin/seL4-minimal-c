Minimal seL4 example in C
=========================

This repo demonstrates a minimal build of the [seL4 micro-kernel] along
with a very simple ('hello world') roottask, implemented in C.

Rather than using seL4's wider build-system throughout, this only uses it
to build a minimal set of seL4 ecosystem dependencies.

**Note:** Just because this approach is feasible, does not necessarily
mean it is wise!

The roottask (initrd) is _very_ simple and just uses seL4's debug
system call to write 'Hello, World!' to the serial console.


Motivation
----------

seL4's standard build system felt a bit invasive to me. It seems wrong
that I should have my build system dictated to me by the kernel. I'm also
not familiar with CMake, and so the system feels a bit too 'magical'.
That all said, I can see the convenience that it can bring, and perhaps I
will change my view on this over time.


Pre-requisites
--------------

In order to build and run this software, you will need:
- [Git]  (to pull down the only dependency, [seL4], this is in place of
  the [Repo] tool)
- [Make]  (for the overarching build system)
- [CMake]  (to build the kernel, [seL4])
- [Ninja]  (to build the kernel, [seL4])
- [gcc] and [others]?  (to build both, the kernel and roottask)
- [Python]3 and some packages (to build the kernel):
  - [setuptools]: `pip3 install --user setuptools`
  - [sel4-deps]: `pip3 install --user sel4-deps`
- [GNU Binutils]  (ld and objcopy; to build both, the kernel and
  roottask)
- [QEMU]  (to run / simulate in a virtual machine)


Dependencies
------------

We use as few dependencies as possible without making our lives difficult. These are as follows:
- [seL4](https://github.com/seL4/seL4): The [seL4 micro-kernel] itself (along with libsel4, for making syscalls)
- [sel4runtime](https://github.com/seL4/sel4runtime): C runtime for seL4
- [seL4_tools](https://github.com/seL4/seL4_tools): Provides seL4's CMake-based build-system


Usage
-----

First clone this repo:
```shell
git clone https://github.com/daniel-ac-martin/seL4-minimal-c.git
```

Then pull down the dependencies:
```shell
cd seL4-minimal-c
git submodule init
git submodule update
```

To build everything:
```shell
make
```

To build just the kernel:
```shell
make kernel
```

To build just the roottask:
```shell
make initrd
```

To run:
```shell
make run
```

To delete built files:
```shell
make clean
```


Miscellaneous notes
-------------------

- See also:
  - https://github.com/daniel-ac-martin/seL4-minimal-asm
  - https://github.com/daniel-ac-martin/seL4-minimal-zig
- This has been tested on a GNU/Linux system (Fedora 38)
- Thoughts / comments / ideas are welcome in the [issues]


[seL4 micro-kernel]: https://sel4.systems/
[Git]: https://git-scm.com/
[seL4]: https://sel4.systems/
[Repo]: https://source.android.com/docs/setup/download#repo
[Make]: https://www.gnu.org/software/make/
[CMake]: https://cmake.org/
[Ninja]: https://ninja-build.org/
[gcc]: https://gcc.gnu.org/
[others]: https://docs.sel4.systems/projects/buildsystem/host-dependencies.html#base-build-dependencies
[Python]: https://www.python.org/
[setuptools]: https://pypi.org/project/setuptools/
[sel4-deps]: https://pypi.org/project/sel4-deps/
[GNU Binutils]: https://www.gnu.org/software/binutils/
[QEMU]: https://www.qemu.org/
[issues]: https://github.com/daniel-ac-martin/seL4-minimal-c/issues

