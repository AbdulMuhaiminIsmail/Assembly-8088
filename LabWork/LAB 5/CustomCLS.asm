[org 0x0100]

jmp start

clrscr:       
    push es 
    push ax 
    push cx 
    push di 

    mov  ax, 0xb800 
    mov  es, ax             ; point es to video base 
    xor  di, di             ; point di to top left column 

    mov  ax, 0x075F         ; underscore char in normal attribute 
    mov  cx, 1120           ; number of screen locations 
    cld                     ; auto increment mode 
    rep  stosw              ; clear the whole screen 

    mov  ax, 0x072E         ; underscore char in normal attribute 
    mov  cx, 880           ; number of screen locations 
    cld                     ; auto increment mode 
    rep  stosw              ; clear the whole screen 

    pop  di 
    pop  cx 
    pop  ax 
    pop  es 
    ret 

start:
    call clrscr

exit:
    mov ax, 0x4c00
    int 0x21


