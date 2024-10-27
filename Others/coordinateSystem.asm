[org 0x0100]

; declarations

jmp start

cls:
    ; Clear screen by setting all memory to 0
    mov ax, 0xA000
    mov es, ax         ; Set ES to graphics memory
    xor di, di         ; Start at the beginning of the frame buffer
    mov cx, 64000      ; 320x200 resolution (one byte per pixel)
    xor al, al         ; Color 0 (black)

    rep stosb          ; Clear screen
    ret

drawPixelXY:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx

    mov ax, 320          ; load ax with cols per row
    mul byte [bp+6]      ; multiply with rows
    add ax, [bp+4]       ; add cols
    mov di, ax
    mov byte [es:di], 0x0F

    pop dx
    pop cx
    pop bx
    pop ax
    mov sp, bp
    pop bp

    ret 4

drawLine:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx

    mov bx, 0   ; starting value of x (0 < x < 99)
    mov cx, 99

    drawPoint:
        ; bx is x coordinate and ax is y coordinate (y = mx + c)
        mov ax, bx
        mul byte [bp+6]
        add ax, word [bp+4]

        ; determining the signs of x and y
        push ax
        push bx

        mul bx

        cmp ax, 0
        jle diffSigns

        sameSigns:
            pop bx
            pop ax

            mov dx, 100
            sub dx, bx
            mov bx, dx

            add ax, 160
            jmp draw

        diffSigns:
            pop bx
            pop ax

            add bx, 100

            mov dx, 160
            sub dx, ax
            mov ax, dx

        draw:
            push bx
            push ax
            call drawPixelXY

        inc bx
        loop drawPoint

    pop dx
    pop cx
    pop bx
    pop ax
    mov sp, bp
    pop bp

    ret 4

drawXYPlane:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx

    mov ax, 0xA000
    mov es, ax

    ; Y Axis
    mov di, 160
    mov cx, 199
    drawVerticalLine:
        mov byte[es:di], 0x0F
        add di, 320
        loop drawVerticalLine

    ;  X Axis
    mov di, 32000
    mov cx, 319
    drawHorizontalLine:
        mov byte[es:di], 0x0F
        inc di
        loop drawHorizontalLine

    pop dx
    pop cx
    pop bx
    pop ax
    mov sp, bp
    pop bp

    ret

start: 
    mov ax, 0x13
    ;int 0x10

    call cls 
    call drawXYPlane

    mov ax, 1   ; slope
    push ax
    mov ax, 0   ; y intercept
    push ax

    call drawLine

 
exit:
    int 0x16
    int 0x21