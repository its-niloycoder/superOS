# cross compiler location
PREFIX := $(HOME)/opt/cross
TARGET := i686-elf
PATH := $(PREFIX)/bin:$(PATH)
BUILD := ./build

export PREFIX
export TARGET
export PATH


# we can hardcode make routin for each source file
# or we can glob in file system with a pettern

# for now it is hard coded

all: build

build: boot keanel usr
	# $(PREFIX)/bin/$(TARGET)-gcc -T LINKER.ld -nostdlib
	

boot: src/startup/x86.nasm
	nasm src/startup/x86.nasm -o $(BUILD)/x86.boot


# Clean target
clean:
	@echo "cleaning the mass"