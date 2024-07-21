[bits 16]
[org 0x7E00]    ; NOTE: Investigate why everything breaks without this origin here
SECTION .text

%define ENDL 0x0D, 0x0A



_stage2_start:
    ; Print the string using BIOS interrupt 10h
    mov si, msg_hello       ; SI points to the start of the message
.print_loop:
    lodsb                 ; Load the next byte from DS:SI into AL, increment SI
    test al, al           ; Check if the byte is null (end of string)
    jz .done              ; If zero, we are done
    mov ah, 0x0E          ; BIOS teletype output function
    mov bh, 0x00          ; Page number (always 0)
    mov bl, 0x07          ; Text attribute (white on black)
    int 0x10              ; Call BIOS interrupt 10h
    jmp .print_loop       ; Repeat for the next character

.done:
    jmp $

msg_hello: db 'Hello world from STAGE TWO BOOTLOADER!', ENDL,  0


GDT_Start:
    null_descriptor:
        dd  0
        dd  0
    code_descriptor:
        dw 0xffff
        dw 0            ; 16 bits +
        db 0            ; 8 bits = 24
        db 0b10011010   ; type flags
        db 0b11001111   ; other flags
        db 0            ; last 8 bits of base
    data_descriptor:
        dw 0xffff
        dw 0
        db 0
        db 0b10010010
        db 0b11001111
        db 0
GDT_End:

GDT_Descriptor:
    dw GDT_End - GDT_Start - 1  ; size
    dd GDT_Start                ; start

