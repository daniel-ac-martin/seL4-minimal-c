CC ?= gcc
AR ?= ar

arch ?= x86_64
plat ?= pc99

arch_family_x86_64 = x86
arch_family_x86 = x86
word_size_x86_64 = 64
word_size_x86 = 32

CFLAGS_x86_64 = -m64 -D__KERNEL_64__ -march=nehalem
qemu_flags_x86_64 = -machine pcspk-audiodev=snd0 -cpu Nehalem,-vme,+pdpe1gb,-xsave,-xsaveopt,-xsavec,-fsgsbase,-invpcid,+syscall,+lm,enforce -serial mon:stdio -m size=512M -audiodev pa,id=snd0

arch_family = $(arch_family_$(arch))
word_size = $(word_size_$(arch))

#CFLAGS ?= -g -ffreestanding -Wall -Wextra -fno-exceptions -std=gnu11 $(CFLAGS_$(arch))
CFLAGS ?= -g -std=gnu11 -nostdinc -fno-pic -fno-pie -fno-stack-protector -fno-asynchronous-unwind-tables -ftls-model=local-exec -mtls-direct-seg-refs $(CFLAGS_$(arch))
CLINK_FLAGS ?= -Wl,-m,elf_x86_64 -static -nostdlib -Wl,-z,max-page-size=0x1000 -Wl,-u_sel4_start -Wl,-e_sel4_start -Wl,--require-defined,main

qemu ?= qemu-system-$(arch)
qemu_flags ?= $(qemu_flags_$(arch))

INCLUDE = deps/seL4/seL4/libsel4/arch_include/$(arch_family)/ \
	  deps/seL4/seL4/libsel4/include/ \
	  deps/seL4/seL4/libsel4/mode_include/$(word_size)/ \
	  deps/seL4/seL4/libsel4/sel4_arch_include/$(arch)/ \
	  deps/seL4/seL4/libsel4/sel4_plat_include/$(plat)/ \
	  build/$(arch)-$(plat)/seL4/kernel/gen_config/ \
	  build/$(arch)-$(plat)/seL4/libsel4/arch_include/$(arch_family)/ \
	  build/$(arch)-$(plat)/seL4/libsel4/autoconf/ \
	  build/$(arch)-$(plat)/seL4/libsel4/gen_config/ \
	  build/$(arch)-$(plat)/seL4/libsel4/include/ \
	  build/$(arch)-$(plat)/seL4/libsel4/sel4_arch_include/$(arch)/

SOURCES = $(shell find src -name '*.c')
HEADERS = $(shell find src -name '*.h')
OBJ = ${SOURCES:%.c=build/$(arch)-$(plat)/%.o}

.PHONY: all clean initrd kernel run

all: kernel initrd

clean:
	rm -rf build/

initrd: build/$(arch)-$(plat)/initrd.img
kernel: build/$(arch)-$(plat)/kernel.img

run: build/$(arch)-$(plat)/kernel.img build/$(arch)-$(plat)/initrd.img
	$(qemu) $(qemu_flags) -kernel $(<) -initrd build/$(arch)-$(plat)/initrd.img

build/$(arch)-$(plat)/kernel.img: build/$(arch)-$(plat)/seL4/kernel/kernel.elf
	mkdir -p $(@D)
	objcopy -O elf32-i386 $(<) $(@)

build/$(arch)-$(plat)/initrd.img: build/$(arch)-$(plat)/src/roottask.elf
	mkdir -p $(@D)
	cp $(<) $(@)

build/$(arch)-$(plat)/seL4/build.ninja: seL4/$(arch)-$(plat).cmake seL4/CMakeLists.txt
	mkdir -p $(@D)
	cd $(@D) && cmake \
		-C ../../../$(<) \
		-G Ninja \
		../../../$(<D)

build/$(arch)-$(plat)/seL4/kernel/kernel.elf: build/$(arch)-$(plat)/seL4/build.ninja
	mkdir -p $(@D)
	cd $(@D)/.. && ninja kernel.elf

build/$(arch)-$(plat)/seL4/libsel4/libsel4.a: build/$(arch)-$(plat)/seL4/build.ninja
	mkdir -p $(@D)
	cd $(@D)/.. && ninja libsel4.a

build/$(arch)-$(plat)/seL4/sel4runtime/libsel4runtime.a: build/$(arch)-$(plat)/seL4/build.ninja
	mkdir -p $(@D)
	cd $(@D)/.. && ninja libsel4runtime.a

build/$(arch)-$(plat)/seL4/musllibc/build-temp/lib/libc.a: build/$(arch)-$(plat)/seL4/build.ninja
	mkdir -p $(@D)
	cd $(@D)/../../.. && ninja musllibc/muslc_gen

build/$(arch)-$(plat)/src/roottask.elf: build/$(arch)-$(plat)/seL4/sel4runtime/libsel4runtime.a build/$(arch)-$(plat)/seL4/libsel4/libsel4.a build/$(arch)-$(plat)/seL4/musllibc/build-temp/lib/libc.a $(OBJ)
	mkdir -p $(@D)
	#$(CC) $(CFLAGS) -v $(CLINK_FLAGS) -Wl,-T deps/seL4/seL4_tools/cmake-tool/helpers/tls_rootserver.lds -o $(@) $(^)
	$(CC) $(CFLAGS) -v $(CLINK_FLAGS) -Wl,-T deps/seL4/seL4_tools/cmake-tool/helpers/tls_rootserver.lds /home/dacm/Projects/seL4-os/build/lib/crt0.o /home/dacm/Projects/seL4-os/build/lib/crti.o /usr/lib/gcc/x86_64-redhat-linux/13/crtbegin.o $(OBJ) -Wl,--start-group -lgcc -lgcc_eh build/$(arch)-$(plat)/seL4/sel4runtime/libsel4runtime.a build/$(arch)-$(plat)/seL4/libsel4/libsel4.a build/$(arch)-$(plat)/seL4/musllibc/build-temp/lib/libc.a -Wl,--end-group /usr/lib/gcc/x86_64-redhat-linux/13/crtend.o /home/dacm/Projects/seL4-os/build/lib/crtn.o -o $(@)

build/$(arch)-$(plat)/src/%.o: src/%.c $(HEADERS) $(INCLUDE)
	mkdir -p $(@D)
	$(CC) $(CFLAGS) $(INCLUDE:%=-I %) -c $(<) -o $(@)
