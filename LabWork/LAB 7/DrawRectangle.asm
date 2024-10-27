[org 0x0100]

jmp start

drawRectangle:
    push bp
	mov bp,sp
    push ax
	push bx
	push cx
	push dx
	
	mov ax, 0xB800
	mov es, ax
	mov bx, 0
	mov cx, 0
	
	mov ax, 80
	mul byte[bp+12]
	add ax, word[bp+10]
	shl ax, 1
	mov di, ax
		
	outerloop2:
		cmp bx, word[bp+8]
		je end2

		mov cx, 0
		mov ax, word[bp+4]
		
		innerloop2:
			cmp cx, word[bp+6]
			je reset2
			 
			mov word[es:di], ax
			add di, 2
			inc cx
			jmp innerloop2
			
		reset2:
			inc bx
			mov ax, 80
			mov cx, [bp+12]
			add cx, bx
			mul cx
			add ax, word[bp+10]
			shl ax, 1
			mov di, ax
			jmp outerloop2
	
	end2:	    
		pop dx
		pop cx
		pop bx
		pop ax 
		mov sp,bp
		pop bp
		ret 10

start:
    mov ax, 7
    push ax
    mov ax, 5
    push ax
    mov ax, 5
    push ax
    mov ax, 40
    push ax
    mov ax, 0x072A
    push ax

    call drawRectangle

exit:
    mov ax, 0x4c00
    int 0x21