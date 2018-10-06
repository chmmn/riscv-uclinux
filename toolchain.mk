
TOPDIR=$(shell 'pwd')

PREFIX=/opt/riscv-nommu
TARGET=riscv32-unknown-linux-gnu
ARCH=rv32ima
ABI=ilp32
SYSROOT=$(PREFIX)/sysroot

srcs = elf2flt linux uclibc-ng riscv-binutils-gdb riscv-gcc
srcdirs = $(patsubst %,$(TOPDIR)/src/%,$(srcs))

sources:$(srcdirs)
	for d in $(srcdirs); do cd "$$d" && git pull; done

$(TOPDIR)/src/elf2flt:
	cd $(TOPDIR)/src && git clone -b riscv https://github.com/chmmn/elf2flt.git

$(TOPDIR)/src/linux:
	cd $(TOPDIR)/src && git clone -b riscv https://github.com/chmmn/linux.git

$(TOPDIR)/src/uclibc-ng:
	cd $(TOPDIR)/src && git clone -b riscv https://github.com/chmmn/uclibc-ng.git

$(TOPDIR)/src/riscv-binutils-gdb:
	cd $(TOPDIR)/src && git clone https://github.com/riscv/riscv-binutils-gdb.git

$(TOPDIR)/src/riscv-gcc:
	cd $(TOPDIR)/src && git clone https://github.com/riscv/riscv-gcc.git

binutils_config:
	-mkdir -p $(TOPDIR)/build/binutils && cd $(TOPDIR)/build/binutils && $(TOPDIR)/src/riscv-binutils-gdb/configure --prefix=$(PREFIX) --target=$(TARGET) --with-sysroot=$(SYSROOT) --disable-multilib --disable-werror --disable-nls --with-expat=yes --disable-gdb

binutils_build:
	cd $(TOPDIR)/build/binutils && make -j10
binutils_install:
	cd $(TOPDIR)/build/binutils && make install

gcc1_config:
	-mkdir -p $(TOPDIR)/build/gcc1
	cd $(TOPDIR)/build/gcc1 && $(TOPDIR)/src/riscv-gcc/configure --prefix=$(PREFIX) --target=$(TARGET) --with-sysroot=$(SYSROOT) --with-newlib --without-headers --disable-shared --disable-threads --with-system-zlib --enable-tls --enable-languages=c --disable-libatomic --disable-libmudflap --disable-libssp --disable-libquadmath --disable-libgomp --disable-nls --disable-bootstrap  --enable-checking=yes --disable-multilib --with-abi=$(ABI) --with-arch=$(ARCH)

gcc1_build:
	cd $(TOPDIR)/build/gcc1 && make -j10
gcc1_install:
	cd $(TOPDIR)/build/gcc1 && make install

headers_config:
headers_build:
	echo $@

headers_install:
	cd $(TOPDIR)/src/linux && make ARCH=riscv CROSS_COMPILE=$(PREFIX)/bin/$(TARGET)- nommu_defconfig && make ARCH=riscv CROSS_COMPILE=$(PREFIX)/bin/$(TARGET)- headers_install INSTALL_HDR_PATH=$(TOPDIR)/src/linux-headers 

uclibc-ng_config:
	cp files/uclibc/$(ARCH) $(TOPDIR)/src/uclibc-ng/.config
	echo KERNEL_HEADERS=\"$(TOPDIR)/src/linux-headers/include\" >> $(TOPDIR)/src/uclibc-ng/.config
	echo RUNTIME_PREFIX=\"\" >> $(TOPDIR)/src/uclibc-ng/.config
	echo DEVEL_PREFIX=\"/usr\" >> $(TOPDIR)/src/uclibc-ng/.config
	echo CROSS_COMPILER_PREFIX=\"$(PREFIX)/bin/$(TARGET)-\" >> $(TOPDIR)/src/uclibc-ng/.config
	cd $(TOPDIR)/src/uclibc-ng && make ARCH=riscv64 CROSS_COMPILE=$(PREFIX)/bin/$(TARGET)- menuconfig

uclibc-ng_build:
	cd $(TOPDIR)/src/uclibc-ng && make ARCH=riscv64 CROSS_COMPILE=$(PREFIX)/bin/$(TARGET)-
uclibc-ng_install:
	cd $(TOPDIR)/src/uclibc-ng && make ARCH=riscv64 CROSS_COMPILE=$(PREFIX)/bin/$(TARGET)- install DESTDIR=$(SYSROOT)
	cp $(TOPDIR)/src/linux-headers/include/* $(SYSROOT)/usr/include/ -a

gcc2_config:
	-mkdir -p $(TOPDIR)/build/gcc2
	cd $(TOPDIR)/build/gcc2 && $(TOPDIR)/src/riscv-gcc/configure --prefix=$(PREFIX) --target=$(TARGET) --with-sysroot=$(SYSROOT) --disable-shared --disable-threads --with-system-zlib --enable-tls --enable-languages=c,c++ --disable-libatomic --disable-libmudflap --disable-libssp --disable-libquadmath --disable-libgomp --disable-nls --disable-bootstrap  --enable-checking=yes --disable-multilib --with-abi=$(ABI) --with-arch=$(ARCH) CFLAGS_FOR_TARGET="-Os -fPIC"

gcc2_build:
	cd $(TOPDIR)/build/gcc2 && make -j10
gcc2_install:
	cd $(TOPDIR)/build/gcc2 && make install

elf2flt_config:
	-mkdir -p $(TOPDIR)/build/elf2flt
	cd $(TOPDIR)/build/elf2flt && $(TOPDIR)/src/elf2flt/configure --target=riscv32-unknown-linux-gnu --with-libbfd=$(TOPDIR)/build/binutils/bfd/libbfd.a --with-libiberty=$(TOPDIR)/build/binutils/libiberty/libiberty.a --with-bfd-include-dir=$(TOPDIR)/build/binutils/bfd/ --with-binutils-include-dir=$(TOPDIR)/src/riscv-binutils-gdb/include

elf2flt_build:
	cd $(TOPDIR)/build/elf2flt && make
elf2flt_install:
	cd $(TOPDIR)/build/elf2flt && make install prefix=$(PREFIX) && cp $(TOPDIR)/src/elf2flt/elf2flt-riscv.ld $(PREFIX)/$(TARGET)/lib/elf2flt.ld -a

