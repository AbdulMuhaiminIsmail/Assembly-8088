[org 0x0100]

jmp start

;subroutine to clear the screen
cls:
    ;backup previous register values
    push es
    push ax
    push di
    ;setup video mode
    mov ax, 0xb800
    mov es, ax
    mov di, 0
    ;clears one pixel at a time
    clrpixel:
        mov word [es:di], 0x0720
        add di, 2
        cmp di, 4000
        jne clrpixel
    ;set previous values of registers
    pop di
    pop ax
    pop es
    ret

printnum:
    push bp                ; Save the base pointer
    mov bp, sp             ; Set the stack pointer to the base pointer
    push es                ; Save ES register
    push ax                ; Save AX register
    push bx                ; Save BX register
    push cx                ; Save CX register
    push dx                ; Save DX register
    push di                ; Save DI register

    mov  ax, 0xb800        ; Video memory base address for color text mode
    mov  es, ax            ; Point ES to the video memory

    mov  ax, [bp+4]        ; Load the number to be printed (parameter passed to the subroutine)
    mov  bx, 10            ; Use base 10 for division (decimal)
    mov  cx, 0             ; Initialize digit count to 0

nextdigit:
    mov  dx, 0             ; Clear DX (upper half of the dividend)
    div  bx                ; Divide AX by 10, quotient in AX, remainder in DL
    add  dl, 0x30          ; Convert the remainder (digit) to ASCII
    push dx                ; Save ASCII value of the digit on the stack
    inc  cx                ; Increment digit count
    cmp  ax, 0             ; Check if quotient is zero
    jnz  nextdigit         ; If quotient is not zero, continue dividing

    mov  di, 30             ; Point DI to the top left of the screen (starting position)

nextpos:
    pop  dx                ; Pop a digit from the stack
    mov  dh, 0x0F          ; Set text attribute (normal color)
    mov [es:di], dx        ; Print the digit (ASCII value) at the current screen position
    add  di, 2             ; Move to the next screen position (each character is 2 bytes in VGA text mode)
    loop nextpos           ; Repeat for all digits on the stack

    ; Restore registers before returning from the subroutine
    pop  di
    pop  dx
    pop  cx
    pop  bx
    pop  ax
    pop  es
    pop  bp
    ret  2                 ; Return and clean up the stack (2 bytes for the parameter)

start:
    mov ax, 0xb800
    mov es, ax
    xor di, di
    call cls
    
    loop1:   
        mov ah, 0x00
        int 0x16

        cmp al, 97
        jl next

        cmp al, 122
        jg next

        sub al, 32

        mov ah, 0x0F

        mov [es:di], ax

        xor ah, ah
        push ax
        call printnum

        next:
            jmp loop1

exit:
    mov ax, 0x4c00
    int 0x21