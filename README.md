riscv uclinux
==================================================

# Quickstart
```
$ git clone https://github.com/chmmn/riscv-uclinux.git
$ cd riscv-uclinux
$ make -f toolchain.mk sources
$ for i in binutils gcc1 headers uclibc-ng gcc2 elf2flt;do make -f toolchain.mk ${i}_config; make -f toolchain.mk ${i}_build; make -f toolchain.mk ${i}_install; done
$ /opt/riscv-nommu/bin/riscv32-unknown-linux-gnu-g++ -v
```

# Build flat binary.
```
$ riscv32-unknown-linux-gnu-gcc -c -fPIC -O2 main.c
$ riscv32-unknown-linux-gnu-gcc -Wl,-elf2flt=-r main.o -o main
```

# Linux image
```
$ wget https://www.whatfun.me/riscv/vmlinux.bz2
$ bunzip2 vmlinux.bz2
$ spike --isa=rv32ima vmlinux
```
  or
```
# qemu-system-riscv32 -kernel vmlinux -nographic
```
