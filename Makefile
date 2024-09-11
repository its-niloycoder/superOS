# cross compiler location
PREFIX := $(HOME)/opt/cross
PATH := $(PREFIX)/bin:$(PATH)
TARGET := i686-elf
BUILD := ./build

export PREFIX
export TARGET
export PATH


# we can hardcode make routin for each source file
# or we can glob in file system with a pettern

# for now it is hard coded

all: run

run: boot
	qemu-system-x86_64 -hda $(BUILD)/x86.boot

build: boot keanel usr
	# $(PREFIX)/bin/$(TARGET)-gcc -T LINKER.ld -nostdlib
	

boot: src/startup/x86.nasm
	nasm -f bin src/startup/x86.nasm -o $(BUILD)/x86.boot


# Clean target
clean:
	@echo "cleaning the mass"