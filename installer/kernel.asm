[bits 16]
[org 0x7e00]

mov [BOOT_DRIVE], dl

; makes stack pointer to be at 0x9e00
push bp
mov bp, 0x9e00
mov sp, bp
pop bp

mov si, BOOT_DRIVE_STR
call printf
mov dx, [BOOT_DRIVE]
call print_hex

mov si, KERNEL_LOADED_STR
call printf

mov si, MEMORY_SIZE_STR
call printf

mov ah, 0xe8
mov al, 0x01
int 0x15 ; get memory size
mov dx, ax
call print_hex

call load_stock_kernel

call os_install_start

jmp panic

%include "printf.asm"

%include "install.asm"

%include "print_hex.asm"

load_stock_kernel:
    mov ah, 0x02
    mov al, 2
    mov ch, 00h
    mov dh, 00h
    mov cl, 4
    mov bx, 0x8000
    int 0x13
    jc .error
    ret
.error:
    mov si, DISK_ERROR
    call printf
    jmp $

panic:
    mov si, KERNEL_PANIC_MSG
    call printf
    jmp $

KERNEL_PANIC_MSG: db "Kernel Panic.", 0xd, 0xa, 0
KERNEL_LOADED_STR: db "Kernel loaded.", 0xd, 0xa, 0
DISK_ERROR: db "Error reading disk!", 0xd, 0xa, 0

MEMORY_SIZE_STR: db "Memory Size: ", 0

BOOT_DRIVE_STR: db "Boot Drive: ", 0

BOOT_DRIVE: db 0xFF

times 1024-($-$$) db 0