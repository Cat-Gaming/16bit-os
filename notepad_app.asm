notepad_app_start:
    mov si, NOTEPAD_APP_PROMPT
    call printf

notepad_app_loop:
    mov ah, 0x00
    int 0x16
    cmp al, 0x1b ; esc keycode
    je .end
    mov ah, 0x0e
    cmp al, 0xd
    je .newline
    cmp al, 0xa
    je .newline
    cmp al, 0x8
    je .backspace
    int 0x10
    jmp notepad_app_loop
.newline:
    mov al, 0xd
    int 0x10
    mov al, 0xa
    int 0x10
    jmp notepad_app_loop
.backspace:
    mov al, 0x8
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 0x8
    int 0x10
    jmp notepad_app_loop
.end:
    mov ah, 0x0e
    mov al, 0xd
    int 0x10
    mov al, 0xa
    int 0x10
    ret

NOTEPAD_APP_PROMPT: db "You have opened the Notepad App! Press Escape to exit out of Notepad App", 0xd, 0xa, 0