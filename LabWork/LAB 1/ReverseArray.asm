[org 0x0100]

mov si, array1+10
mov di, array2
mov cx, 6

l:  mov ax, [si]
    mov [di], ax
    sub si, 2
    add di, 2
    sub cx, 1
    jnz l

mov ax, 0x4c00
int 0x21

array1: dw 1, 2, 3, 4, 5, 6
array2: dw 0, 0, 0, 0, 0, 0