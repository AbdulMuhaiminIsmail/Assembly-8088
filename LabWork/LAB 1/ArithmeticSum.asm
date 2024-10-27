[org 0x0100]

mov ax, [N]
mov bx, [N]
sub bx, 1

l:     add ax, bx
        sub bx, 1
        jnz l

mov [sum], ax
mov ax, 0x4c00
int 0x21

N: dw 6
sum: dw 0
