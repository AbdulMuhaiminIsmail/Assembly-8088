; Program to clear the screen using assembly language
; This code writes ascii to every character cell in the video memory (B800:0000).
; It is written for real mode and terminates the program after clearing the screen.

[org 0x0100]              ; Set the origin address for the program

; Load the video memory segment (0xB800) into ES register
mov ax, 0xb800            ; Video base address for text mode (80x25 screen)
mov es, ax                ; Point ES to video memory segment

; Initialize DI to 0 to point to the top-left corner of the screen
mov di, 0                 ; DI will be used to navigate the video memory (starting from 0xB800:0000)
mov ax, 0x0700            ; Set first ASCII char in white colour to be printed

; Loop through the entire screen to print each character
nextchar:
    mov word [es:di], ax      ; Write a space (0x20) with attribute (0x07 = white on black)
    add di, 2                 ; Move to the next character position (each character cell = 2 bytes)
    inc al
    cmp di, 4000              ; Check if we’ve reached the end of the screen (80x25 = 2000 cells * 2 bytes)
    jne nextchar              ; If not, repeat the process for the next character

; Terminate the program
mov ax, 0x4c00              ; DOS interrupt to terminate the program
int 0x21                    ; Call DOS interrupt 21h to exit

