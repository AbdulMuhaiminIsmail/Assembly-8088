[org 0x0100]

jmp start

arr: dw 1,1,2,2,2,2,4,4,4,4,4
count: dw 22
mode: dw -1

start:
    mov bx, 0
    mov cx, bx
    mov dx, cx
    mov ax, [arr+bx]
    jmp main

main:
    cmp bx, [count]
    jge exit

    cmp [arr+bx], ax
    je dxInc

    cmp cx, dx
    jl updateMode

dxInc:
    inc dx
    add bx, 2
    jmp main

updateMode:
    mov [mode], ax
    mov ax, [arr+bx]
    mov cx, dx
    mov dx, 0
    inc bx
    jmp main

exit:
    mov ax, 0x4c00
    int 0x21

; ax contains the current recurring number
; bx is iterator index
; cx is the max frequency
; dx is ax's frequency


