[org 0x0100]

jmp start

subtract:
    push bp
    mov bp, sp

    mov ax, [bp+10]
    sub ax, [bp+8]
    sub ax, [bp+6]
    sub ax, [bp+4]

    mov sp, bp
    pop bp

    ret 8

start:
    ; function call Test i 
    push 0xA 
    Push 0x1 
    Push 0x2 
    Push 0x2 
    Call subtract 

    ; function call Test ii 
    push 0x9 
    Push 0x1 
    Push 0x5 
    Push 0x0 
    Call subtract 

    ; function call Test iii 
    push 0xF 
    Push 0x1 
    Push 0x8 
    Push 0x4 
    Call subtract 

exit:
    mov ax, 0x4c00
    int 0x21