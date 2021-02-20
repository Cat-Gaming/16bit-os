[bits 16]
[org 0x7e00]

mov [BOOT_DRIVE], dl

; makes stack pointer to be at 0x9000
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

call cli_start

jmp panic

%include "printf.asm"

%include "notepad_app.asm"

%include "cli.asm"

%include "print_hex.asm"

panic:
    mov si, KERNEL_PANIC_MSG
    call printf
    jmp $

KERNEL_PANIC_MSG: db "Kernel Panic.", 0xd, 0xa, 0
KERNEL_LOADED_STR: db "Kernel loaded.", 0xd, 0xa, 0

MEMORY_SIZE_STR: db "Memory Size: ", 0

BOOT_DRIVE_STR: db "Boot Drive: ", 0

BOOT_DRIVE: db 0xFF

times 1024-($-$$) db 0