[org 0x0100]

jmp start

string: db 'Muhaimin King', 0

; Subroutine to clear the screen 
clrscr: 
    push es 
    push ax 
    push cx 
    push di 
    mov ax, 0xb800 
    mov es, ax        ; Point ES to video base 
    xor di, di        ; Point DI to top left corner 
    mov ax, 0x0720    ; Space char with normal attribute 
    mov cx, 2000      ; Number of screen locations 
    cld               ; Auto-increment mode 
    rep stosw         ; Clear the whole screen 
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

    mov di, [bp+4]    ; Load the string
    xor al, al        ; Null for comparison
    mov cx, 0xffff    ; Max possible length
    repne scasb       ; Search for null terminator
    mov ax, 0xffff    
    sub ax, cx        ; Calculate string length
    dec ax            ; Adjust for null terminator

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

    mov ax, [bp+4]      ; Load string
    push ax
    call strlen         ; Store length in AX

    cmp ax, 0
    jz exit             ; Return if empty

    mov cx, ax          ; Load length into CX
    mov ax, 0xb800      ; Setup video mode
    mov es, ax

    mov al, 80          ; Columns per row
    mul byte [bp+10]    ; Multiply by row number
    add ax, [bp+8]      ; Add column offset
    shl ax, 1           ; Convert to byte offset

    mov di, ax          ; Set starting point on screen
    mov si, [bp+4]      ; Load string into SI
    mov ah, [bp+6]      ; Load attribute into AH
    cld

    nextchar:
        lodsb           ; Load next char into AL
        stosw           ; Store AX at ES:DI
        loop nextchar 

    pop dx
    pop cx
    pop bx
    pop ax
    mov sp, bp
    pop bp

    ret 8

creditsLoop:
    mov cx, 25           ; Loop through all rows
    nextRow:
        call clrscr      ; Clear screen
        push cx

        mov ax, 10       ; X coordinate
        mov bx, cx       ; Y coordinate (changes in each iteration)
        mov dx, string   ; String address
        mov cx, 0x0F     ; White on black attribute

        push ax
        push bx
        push cx
        push dx

        call printString ; Render the string

        pop dx
        pop cx
        pop bx
        pop ax
        pop cx

        ; Add a short delay for the effect
        mov cx, 30000
    delayLoop:
        loop delayLoop

        loop nextRow

    jmp creditsLoop      ; Repeat endlessly

start:
    call creditsLoop     ; Start the credits loop

exit:
    mov ax, 0x4c00
    int 0x21
