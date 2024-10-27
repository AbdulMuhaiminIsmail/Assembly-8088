[org 0x0100]

mov ax, [num]
mov bx, ax
mov cx, ax
sub cx, 1

l:  add ax, bx
    sub cx, 1
    jnz l

mov [square], ax
mov ax, 0x4c00
int 0x21

num: dw 9
square: dw 0
