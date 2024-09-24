#############
# Enverment #
#############
# cross compiler location
PREFIX := $(HOME)/opt/cross
PATH := $(PREFIX)/bin:$(PATH)
TARGET := i686-elf

BUILD_DIR := ./build

export PREFIX
export TARGET
export PATH

#########
# Tools #
#########
AS = nasm
CC = $(TARGET)-gcc
LINK = $(TARGET)-ld

# we can hardcode make routin for each source file
# or we can glob in file system with a pettern

# for now it is hard coded

all: run

# dd if=./build/kernel.bin of=$(BUILD)/os_image.bin conv=notrunc

run: build
	qemu-system-i386 -hda $(BUILD_DIR)/os_image.bin

# boot code should build in last because we need to dynamic preprocess in assembly
# to adjust the loader
build: kernel link mk_boot boot join_build  # usr

mk_boot: kernel.bin
	state 

boot: mk_boot src/startup/x86.nasm
	$(AS) -f bin src/startup/x86.nasm -o $(BUILD_DIR)/x86.boot

kernel: src/kernel/kernel_main.c
	$(CC) -ffreestanding -m32 -c src/kernel/kernel_main.c -o $(BUILD_DIR)/kernel.o

link: kernel
	$(LINK) -m elf_i386 -T LINKER.ld --oformat binary -o $(BUILD_DIR)/kernel.bin $(BUILD_DIR)/kernel.o

join_build: link boot
	cat $(BUILD_DIR)/x86.boot $(BUILD_DIR)/kernel.bin > $(BUILD_DIR)/os_image.bin
# 100 as a temporary value it is going to automated in farther in boot section
	dd if=/dev/zero bs=512 count=100 >> $(BUILD)/os_image.bin


# Clean target
clean:
	@echo "cleaning the mass"