[bits 16]

Bootloader:
    mov ah, 0x0e
    mov al, 'B'
    int 0x10
    jmp $

;set stuff up
;find kernel

