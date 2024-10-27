[org 0x0100]

jmp start


start:
    mov ax, 0xb800
    mov es, ax
    mov di, 3840

    ; Initialize loop control variable
    mov cx, 0 ; 
    singleloop:
        cmp cx, 1 ; Check if cx exceeds limit
        je end_loop ; Exit if loop has run desired number of times
    
        ; Your loop logic here
        mov al, '*'
        mov ah, 0x07
        mov word[es:di], ax
        add di, 2
        
        inc cx ; Increment cx by 1
        jmp singleloop ; Repeat loop
    
    end_loop:
    ; End of single loop

exit:
    mov ax, 0x4c00
    int 0x21