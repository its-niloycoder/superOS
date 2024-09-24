all: build emulate

build: main.nasm
	nasm -f bin -o main.bin main.nasm

	dd if=/dev/zero bs=512 count=1 >> main.bin
	# it don't matter because other sectors are considered as 0

emulate: build
	qemu-system-x86_64 -hda ./main.bin