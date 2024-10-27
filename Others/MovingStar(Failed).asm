[org 0x100]

jmp start

X_coordinate: db 0
Y_coordinate: db 0
D_flag: db 'R'

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

    mov dh, 0x07
    mov dl, '*'

    printStar:
        xor ax, ax
        xor bx, bx
                
        mov ax, [X_coordinate]
        mov bx, [Y_coordinate]

        push ax
        push bx

        call moveXY

        cmp di, 0
        je moveRight

        cmp di, 160
        je moveDown

        cmp di, 4000
        je moveLeft

        cmp di, 3838
        je moveUp

        moveRight:
            mov cx, 80

            rightLoop:
                call cls 
                call delay
                mov ax, [X_coordinate]
                mov bx, [Y_coordinate]

                push ax
                push bx

                call moveXY

                mov word[es:di], dx

                inc bx
                mov [Y_coordinate], bx
                loop rightLoop

            jmp printStar

        moveDown:
            mov cx, 25

            downLoop:
                call cls 
                call delay
                mov ax, [X_coordinate]
                mov bx, [Y_coordinate]

                push ax
                push bx

                call moveXY

                mov word[es:di], dx

                inc ax
                mov [X_coordinate], bx
                loop downLoop

            jmp printStar

        moveLeft:
            mov cx, 80

            leftLoop:
                call cls 
                call delay
                mov ax, [X_coordinate]
                mov bx, [Y_coordinate]

                push ax
                push bx

                call moveXY

                mov word[es:di], dx

                dec bx
                mov [Y_coordinate], bx
                loop leftLoop

            jmp printStar

        moveUp:
            mov cx, 25

            upLoop:
                call cls 
                call delay
                mov ax, [X_coordinate]
                mov bx, [Y_coordinate]

                push ax
                push bx

                call moveXY

                mov word[es:di], dx

                dec bx
                mov [X_coordinate], bx
                loop upLoop

    ; printStar:
    ;     call cls
    ;     call delay
       
    ;     mov bx, word[ds:si]
    ;     mov word[ds:si], 0x0720
    ;     mov word[es:di], bx
    ;     add si, 2
    ;     add di, 2

    ;     loop printStar

    pop dx
    pop cx
    pop bx
    pop ax
    mov sp, bp
    pop bp

    ret

start:
    mov ax, 0xb800
    mov es, ax
    mov di, 0

    mov ds, ax
    mov si, 0

    call movingStar

exit:
    mov ax, 0x4c00
    int 0x21