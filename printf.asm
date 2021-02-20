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