AS=nasm
.PHONY: iso

all: compile link iso

iso:
	cp os_installer.bin iso
	truncate iso/os_installer.bin -s 1200k
	mkisofs -b os_installer.bin -o os_installer.iso iso

compile:
	cp ../kernel.asm stock_kernel.asm
	nasm -f bin boot.asm -o boot.bin
	nasm -f bin kernel.asm -o kernel.bin
	nasm -f bin stock_kernel.asm -o stock_kernel.bin

link:
	cp boot.bin os_installer.bin
	cat kernel.bin >> os_installer.bin
	cat stock_kernel.bin >> os_installer.bin

clean:
	rm *.bin
	rm */*.bin
	rm *.iso