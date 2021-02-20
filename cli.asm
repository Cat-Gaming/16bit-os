cli_start:
    call cli_prompt
    mov si, CLI_EXIT_STR
    call printf
    ret

cli_prompt:
    mov ah, 0x0e
    mov al, 0xd
    int 0x10
    mov ah, 0x0e
    mov al, 0xa
    int 0x10

    mov si, CLI_STR
    call printf
    mov si, CLI_PROMPT
    call printf
    jmp cli_select_loop
    ret

cli_select_loop:
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
    cmp al, 't'
    int 0x10
    je .text_edit_launch

    jne cli_prompt

    int 0x10
    jmp cli_select_loop
.newline:
    jmp cli_select_loop
.print_newline:
    mov ah, 0x0e
    mov al, 0xd
    int 0x10
    mov ah, 0x0e
    mov al, 0xa
    int 0x10
    ret
.text_edit_launch:
    call .print_newline
    call notepad_app_start
    jmp cli_prompt
.end:
    mov ah, 0x0e
    mov al, 'e'
    int 0x10
    mov al, 0xd
    int 0x10
    mov al, 0xa
    int 0x10
    ret

CLI_STR: db 'Press "e" to exit out of the CLI and press "t" for a Text Editor', 0xd, 0xa, 0
CLI_PROMPT: db '>', 0
CLI_EXIT_STR: db "Exitted out of CLI", 0xd, 0xa, 0