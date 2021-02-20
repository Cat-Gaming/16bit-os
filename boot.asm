[bits 16]
[org 0x7c00]

mov [BOOT_DRIVE], dl

mov si, BOOT_LOAD_MSG
call printf

call load_kernel

jmp 0x7e00

printf:
    pusha
    mov ah, 0x0e
.loop:
    mov al, [si]
    cmp al, 0
    je .end
    int 0x10
    inc si
    jmp .loop
.end:
    popa
    ret

load_kernel:
    mov ah, 0x02
    mov al, 2
    mov ch, 00h
    mov dh, 00h
    mov cl, 2
    mov bx, 0x7e00
    int 0x13
    jc .error
    ret
.error:
    mov si, DISK_ERROR
    call printf
    jmp $

BOOT_LOAD_MSG: db "Bootloader loaded.", 0xd, 0xa, 0
DISK_ERROR: db "Error reading disk!", 0xd, 0xa, 0

times 509-($-$$) db 0
BOOT_DRIVE: db 0xFF
db 0x55, 0xaa
