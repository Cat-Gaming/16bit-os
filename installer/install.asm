os_install_start:
    call os_install_prompt
    mov si, os_install_EXIT_STR
    call printf
    ret

os_install_prompt:
    mov ah, 0x0e
    mov al, 0xd
    int 0x10
    mov ah, 0x0e
    mov al, 0xa
    int 0x10

    mov si, os_install_WARN
    call printf
    mov si, os_install_STR
    call printf
    mov si, os_install_PROMPT
    call printf
    jmp os_install_select_loop
    ret

install_os:
    mov ah, 0x0e
    mov al, 0xd
    int 0x10
    mov ah, 0x0e
    mov al, 0xa
    int 0x10

    mov si, INSTALLING_OS_MSG
    call printf

    mov ah, 0x03
    mov ch, 0x00
    mov dh, 0x00
    mov dl, 0x80 ; first hard disk
    ; bootloader
    mov cl, 1
    mov al, 1
    mov bx, 0x7c00
    int 0x13
    jc .error_install_os
    ; NEW kernel
    mov ah, 0x03
    mov cl, 2
    mov al, 2
    mov bx, 0x8000
    int 0x13
    jc .error_install_os

    mov si, OS_INSTALLED_MSG
    call printf
    jmp $
.error_install_os:
    mov si, ERROR_INSTALLING_OS
    call printf
    jmp $

os_install_select_loop:
    mov ah, 0x00
    int 0x16
    cmp al, 'e' ; press e to exit
    je .end
    ; default newline commands
    mov ah, 0x0e
    cmp al, 0xd
    je .newline
    cmp al, 0xa
    je .newline
    ; custom commands
    cmp al, 'i'
    int 0x10
    je install_os

    jne os_install_prompt

    int 0x10
    jmp os_install_select_loop
.newline:
    jmp os_install_select_loop
.print_newline:
    mov ah, 0x0e
    mov al, 0xd
    int 0x10
    mov ah, 0x0e
    mov al, 0xa
    int 0x10
    ret
.end:
    mov ah, 0x0e
    mov al, 'e'
    int 0x10
    mov al, 0xd
    int 0x10
    mov al, 0xa
    int 0x10
    ret

os_install_STR: db 'Press "e" to exit out of the OS installer and press "i" to install to the first hard disk', 0xd, 0xa, 0
os_install_WARN: db "Warning! THIS WILL REPLACE YOUR EXISTING OPERATING SYSTEM AND ALL OF YOUR FILES WILL BE LOST!", 0xd, 0xa, 0
os_install_PROMPT: db '>', 0
os_install_EXIT_STR: db "Exitted out of Installer", 0xd, 0xa, 0
INSTALLING_OS_MSG: db "Installing OS...", 0xd, 0xa, 0
OS_INSTALLED_MSG: db "OS Installed.", 0xd, 0xa, "Please Reboot.", 0xd, 0xa, 0
ERROR_INSTALLING_OS: db "Error Installing OS!", 0xd, 0xa, 0