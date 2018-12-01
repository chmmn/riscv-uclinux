riscv uclinux
==================================================

# Download sources
```
$ git clone https://github.com/chmmn/riscv-uclinux.git
$ cd riscv-uclinux
$ make -f toolchain.mk sources
```

# Build GNU toolchain
Edit toolchain.mk:
```
PREFIX=/opt/riscv-nommu
TARGET=riscv32-unknown-linux-gnu
ARCH=rv32ima
ABI=ilp32
```
or
```
PREFIX=/opt/riscv-nommu
TARGET=riscv64-unknown-linux-gnu
ARCH=rv64imafdc
ABI=lp64d
```

build toolchain:
```
$ for i in binutils gcc1 headers uclibc-ng gcc2 elf2flt;do make -f toolchain.mk ${i}_config; make -f toolchain.mk ${i}_build; make -f toolchain.mk ${i}_install; done
```

run gcc:
```
$ /opt/riscv-nommu/bin/riscv32-unknown-linux-gnu-g++ -v
```
or
```
$ /opt/riscv-nommu/bin/riscv64-unknown-linux-gnu-g++ -v
```

# Build flat binary.
```
$ riscv32-unknown-linux-gnu-gcc -c -fPIC -O2 main.c
$ riscv32-unknown-linux-gnu-gcc -Wl,-elf2flt=-r main.o -o main
```

# Prebuilt Linux image
```
$ wget https://www.whatfun.me/riscv/vmlinux.bz2
$ bunzip2 vmlinux.bz2
$ spike --isa=rv32ima vmlinux
```
  or
```
# qemu-system-riscv32 -kernel vmlinux -nographic
```
