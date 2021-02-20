AS=nasm

.PHONY: iso

all: compile link iso

iso:
	cp os.bin iso
	truncate iso/os.bin -s 1200k
	mkisofs -b os.bin -o os_live.iso iso

run:
	qemu-system-x86_64 -fda os.bin

compile:
	nasm -f bin boot.asm -o boot.bin
	nasm -f bin kernel.asm -o kernel.bin

link:
	cp boot.bin os.bin
	cat kernel.bin >> os.bin

clean:
	rm *.bin
	rm */*.bin
	rm *.iso