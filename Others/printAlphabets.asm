[org 0x100]

jmp start

start:
    mov ax, 0xb800
    mov es, ax
    mov di, 0

reset:
    mov bx, 0x0741

nextchar:
    mov word [es:di], bx
    add di, 2
    cmp di, 2080    
    jge exit
    inc bl
    cmp bl, 0x5B
    je reset
    jmp nextchar

exit:
    mov ax, 0x4c00
    int 0x21