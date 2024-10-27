[org 0x0100]

jmp start

string1: db 'Muhaimin King', 0
string2: db 'king 2.0', 0

; subroutine to clear the screen 
clrscr: 
    push es 
    push ax 
    push cx 
    push di 
    mov ax, 0xb800 
    mov es, ax ; point es to video base 
    xor di, di ; point di to top left column 
    mov ax, 0x0720 ; space char in normal attribute 
    mov cx, 2000 ; number of screen locations 
    cld ; auto increment mode 
    rep stosw ; clear the whole screen 
    pop di 
    pop cx 
    pop ax 
    pop es 
    ret 

strlen:
    push bp
    mov bp, sp
    push si
    push cx

    mov di, [bp+4]  ; load the string
    xor al, al      ; null for comparison
    mov cx, 0xffff  ; max possible length
    repne scasb     ; compare null in string
    mov ax, 0xffff  ; load max length
    sub ax, cx      ; calculate actual length
    dec ax          ; subtract 1 because null was also counted

    pop cx
    pop si
    mov sp, bp
    pop bp

    ret 2

printString:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx

    mov ax, [bp+4]      ; load string
    push ax
    call strlen         ; store strlen in ax

    cmp ax, 0
    jz exit             ; return if string is empty

    mov cx, ax          ; load strlen in cx
    mov ax, 0xb800      ; setup text mode
    mov es, ax

    mov al, 80          ; load al with cols per row
    mul byte [bp+10]    ; multiply with rows
    add ax, [bp+8]      ; add cols
    shl ax, 1           ; convert to byte offset (by multiplying by 2)

    mov di, ax          ; setup starting point on screen
    mov si, [bp+4]      ; setup string in si
    mov ah, [bp+6]      ; load attribute in ah

    nextchar:
        lodsb           ; loads char in al
        stosw           ; stores ax on [es:di]
        loop nextchar 

    pop dx
    pop cx
    pop bx
    pop ax
    mov sp, bp
    pop bp

    ret 8

start:
    call clrscr
    mov ax, 0      ; x coordinate
    mov bx, 0      ; y coordinate
    mov cx, 0x0F    ; white on black
    mov dx, string1  ; address of string
    push ax
    push bx
    push cx
    push dx

    call printString 

    mov ax, 1      ; x coordinate
    mov bx, 0      ; y coordinate
    mov cx, 0x0F    ; white on black
    mov dx, string2  ; address of string
    push ax
    push bx
    push cx
    push dx

    call printString 

    mov ax, 2      ; x coordinate
    mov bx, 0      ; y coordinate
    mov cx, 0x0F    ; white on black
    mov dx, string2  ; address of string
    push ax
    push bx
    push cx
    push dx

    call printString 

exit:
    mov ax, 0x4c00
    int 0x21