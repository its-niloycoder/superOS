PREFIX := $(HOME)/opt/cross
TARGET := i686-elf

BUILD_DIR := ./build

AS = nasm
CC = $(TARGET)-gcc
LINK = $(TARGET)-ld

all:
	$(AS) -f elf32 kernel.asm -o $(BUILD_DIR)/kernasm.o
	$(CC) -m32 -c kernel.c -o $(BUILD_DIR)/kernc.o
	$(LINK) -m elf_i386 -T link.ld -o $(BUILD_DIR)/kernel \
		$(BUILD_DIR)/kernasm.o $(BUILD_DIR)/kernc.o
	
	qemu-system-i386 -kernel $(BUILD_DIR)/kernel

clean:
	@echo "cleaning"