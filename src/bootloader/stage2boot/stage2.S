[bits 16]
[org 0x7E00]

_stage2_start:
    mov ah, 0xE
    mov al, 'G'
    int 0x10
    mov ah, 0xE
    mov al, 'o'
    int 0x10
    mov ah, 0xE
    mov al, 'o'
    int 0x10
    mov ah, 0xE
    mov al, 'd'
    int 0x10
    mov ah, 0xE
    mov al, 'b'
    int 0x10
    mov ah, 0xE
    mov al, 'y'
    int 0x10
    mov ah, 0xE
    mov al, 'e'
    int 0x10
    mov ah, 0xE
    mov al, '!'
    int 0x10

    jmp $
