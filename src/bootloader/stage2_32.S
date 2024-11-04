[bits 32]

[global _stage2_32]

[extern _stage2_64]

section .text


_stage2_32:
    mov al, 'A'
    mov ah, 0x0F
    mov [0xB8000], ax

    hlt

    ; jmp to 64 bit land


    ; jmp kernel

    jmp _stage2_64
