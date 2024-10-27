[org 0x100]

jmp start

cls:
    push es
    push ax
    push di

    clrpixel:
        mov word [es:di], 0x0720
        add di, 2
        cmp di, 4000
        jne clrpixel

    pop di
    pop ax
    pop es
    ret

delay:
    push bp
    mov bp, sp
    push cx

    mov cx, 0xFFFF

    delayLoop1:
        loop delayLoop1

    pop cx
    mov sp, bp
    pop bp

    ret

moveXY:
    push bp
    mov bp, sp
    push di

    mov ax, 80
    mul byte[bp+6]
    add ax, word[bp+4]
    shl ax, 1
    mov di, ax

    pop di
    mov sp, bp
    pop bp
    ret 4

movingStar:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push ds
    push si
    push di

    mov ax, 0xb800
    mov es, ax
    mov di, 0

    mov ds, ax
    mov si, 0

    mov dh, 0x07
    mov dl, '*'

    mov word[es:di], dx
    add di, 2

    call cls 

    mov cx, 79
    printRight:
        call delay
       
        mov bx, word[ds:si]
        mov word[ds:si], 0x0720
        mov word[es:di], bx
        add si, 2
        add di, 2

        loop printRight

    mov cx, 24
    add di, 158
    printDown:
        call delay
        
        mov bx, word[ds:si]
        mov word[ds:si], 0x0720
        mov word[es:di], bx

        mov si, di
        add di, 160

        loop printDown

    mov cx, 79
    mov di, 3996
    printLeft:
        call delay
       
        mov bx, word[ds:si]
        mov word[ds:si], 0x0720
        mov word[es:di], bx
        mov si, di
        sub di, 2

        loop printLeft

    mov cx, 24
    mov di, 3680
    printUp:
        call delay
        
        mov bx, word[ds:si]
        mov word[ds:si], 0x0720
        mov word[es:di], bx

        mov si, di
        sub di, 160

        loop printUp

    pop di
    pop si
    pop ds
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    mov sp, bp
    pop bp

    ret

start:
    call movingStar
    jmp start

exit:
    mov ax, 0x4c00
    int 0x21