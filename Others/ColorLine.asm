[org 0x0100]

jmp start

message db 'Welcome to Assembly Language', 0
oldisr dd 0

cls:
    push es
    push ax
    push di
    
    mov ax, 0xb800
    mov es, ax
    mov di, 0
    
clrpixel:
    mov word [es:di], 0x0720
    add di, 2
    cmp di, 4000
    jne clrpixel
    
    pop di
    pop ax
    pop es
    ret

displayWelcome:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx

    call cls
    mov ah, 0x02
    mov bh, 0x00
    mov dh, 11
    mov dl, 23
    int 10h

    mov ax, [bp+4]
    push ax
    call printMessage

end:
    pop dx
    pop cx
    pop bx
    pop ax
    mov sp, bp
    pop bp

    ret 2

printMessage:
    push bp
    mov bp, sp
    push ax
    push cx
    push es
    push di
    push si

    mov ax, 0xb800
    mov es, ax
    mov di, 1810

    ;set len and str in cx and si respectively
    mov si, message
    mov ax, [bp+4] ;set color of text 
    
    printNextChar:
        mov al, [si] ;set char value in code byte
        cmp al, 0 ;check if end of string
        je endPrint
        mov word [es:di], ax
        add di, 2
        inc si
        jmp printNextChar

endPrint:
    pop si
    pop di
    pop es
    pop cx
    pop ax
    pop bp

    ret 4

kbisr:
    push ax
    push es

    mov ax, 0xb800
    mov es, ax

    in al, 0x60

checkG:
    cmp al, 0x22
    jne checkR
    push word 0x0200
    call displayWelcome

checkR:
    cmp al, 0x13  
    jne endkbisr
    push word 0x0400
    call displayWelcome

endkbisr:
    pop es
    pop ax
    jmp far [cs:oldisr]

start:
    xor ax, ax
    mov es, ax

    mov ax, [es:9*4]
    mov [oldisr], ax
    mov ax, [es:9*4+2]
    mov [oldisr + 2], ax

    cli 
    mov word [es:9*4], kbisr
    mov [es:9*4+2], cs
    sti

    mov ax, 0xb800
    mov es, ax

    mov ax, 0x0F00
    push ax
    call displayWelcome

    jmp $

exit:
    mov ax, 0x4c00
    int 0x21