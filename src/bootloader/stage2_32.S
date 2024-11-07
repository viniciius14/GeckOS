[bits 32]

[global _stage2_32]

[extern _stage2_64]

%include "boot_utils_32.S"

section .text

_stage2_32:
    mov al, 'B'
    mov ah, 0x0F
    mov [0xB8000], ax

    call checkCPUID


    mov al, 'C'
    mov ah, 0x0F
    mov [0xB8000], ax

; Disable paging
; Set the PAE enable bit in CR4
; Load CR3 with the physical address of the PML4 (Level 4 Page Map)
; Enable long mode by setting the LME flag (bit 8) in MSR 0xC0000080 (aka EFER)
; Enable paging

    hlt

    ; jmp to 64 bit land


    ; jmp kernel

    jmp _stage2_64

section .data
msg_random: db "Heres a random message! And its wayyy longer than the ususal messages!", ENDL