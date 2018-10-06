
TOPDIR=$(shell 'pwd')

elf2flt:
	cd $(TOPDIR)/src && git clone -b riscv https://github.com/chmmn/elf2flt.git

kernel:
	cd $(TOPDIR)/src && git clone -b riscv https://github.com/chmmn/linux.git

libc:
	cd $(TOPDIR)/src && git clone -b riscv https://github.com/chmmn/uclibc-ng.git

binutils:
	cd $(TOPDIR)/src && git clone https://github.com/riscv/riscv-binutils-gdb.git

gcc:
	cd $(TOPDIR)/src && git clone https://github.com/riscv/riscv-gcc.git

