# cross compiler location
PREFIX := $(HOME)/opt/cross
PATH := $(PREFIX)/bin:$(PATH)
TARGET := i686-elf
BUILD := ./build

export PREFIX
export TARGET
export PATH

CC = $(TARGET)-gcc
LINK = $(TARGET)-ld

all: build Emulate

build:
	# Flag explains
	# 
	# $(CC) -ffreestanding -m32 -c bootloader.c -o bootloader.o

	$(CC) -ffreestanding -m32 -c kernel_main.c -o kernel.o
	$(LINK) -m elf_i386 -T LINKER.ld kernel.o -o kernel.bin

Emulate:

# Emulate:
# 	# dd if=/dev/zero of=os_image.bin bs=512 count=2880 # 1.4MB
# 	truncate -s 1474560 os_image.bin

# 	dd if=kernel.bin of=os_image.bin conv=notrunc
# 	qemu-system-i386 -drive format=raw,file=os_image.bin