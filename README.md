# riscv uclinux


## Download sources
```
$ git clone https://github.com/chmmn/riscv-uclinux.git
$ cd riscv-uclinux
$ make -f toolchain.mk sources
```

## Build GNU toolchain
### Edit toolchain.mk:
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

### Build toolchain:
```
$ for i in binutils gcc1 headers uclibc-ng gcc2 elf2flt;do make -f toolchain.mk ${i}_config; make -f toolchain.mk ${i}_build; make -f toolchain.mk ${i}_install; done
```

### Run gcc:
```
$ /opt/riscv-nommu/bin/riscv32-unknown-linux-gnu-g++ -v
```
or
```
$ /opt/riscv-nommu/bin/riscv64-unknown-linux-gnu-g++ -v
```

## Build flat binary.
```
$ riscv32-unknown-linux-gnu-gcc -c -fPIC -O2 main.c -o main.o
$ riscv32-unknown-linux-gnu-gcc -Wl,-elf2flt=-r main.o -o main
```

## Prebuilt busybox root cpio file
### 32bit 
```
wget https://www.whatfun.me/riscv/uClinux/rootfs32.cpio.gz
```
### 64bit 
```
wget https://www.whatfun.me/riscv/uClinux/rootfs64.cpio.gz
```

## Prebuilt vmlinux
### 32bit
```
$ wget https://www.whatfun.me/riscv/vmlinux32.bz2
$ bunzip2 vmlinux32.bz2
```
run it
```
$ spike --isa=rv32ima -m0x80000000:0x60000000 vmlinux
```
  or
```
# qemu-system-riscv32 -kernel vmlinux -nographic
```

### 64bit
```
$ wget https://www.whatfun.me/riscv/vmlinux64.bz2
$ bunzip2 vmlinux64.bz2
```
run it
```
$ spike --isa=rv64imafdc vmlinux
```
  or
```
# qemu-system-riscv64 -kernel vmlinux -nographic
```
