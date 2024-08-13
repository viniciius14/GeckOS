[bits 16]

%include "header.S"

section .text

S2_LOAD_SEGMENT     equ 0x0
S2_LOAD_OFFSET      equ 0x7E00

_stage1_start:
    %ifdef DEBUG
        ; TBD: check that the value in CS is 0x7C00
        ; TBD: check that the value in DL is 0x80 for HDD or 0x00 for floppy
        ; TBD: check that the value in SP is 0x7C00
    %endif

    cli                 ; Clear interrupt flag
    cld                 ; Clear direction flag

	mov ax, 0           ; Clear main registers
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7C00

    call load_stage_2   ; Load stage2 of the bootloader into RAM address 0x7E00

    ; Info to be "sent" to stage 2
    mov ax, [bdb_sectors_per_track]
    mov bx, [bdb_heads]
    mov cx, BOOT_2_SECTORS

    jmp S2_LOAD_SEGMENT:S2_LOAD_OFFSET

%include "boot_utils.S"
%include "load_stage2.S"

section .text
times (510 - ($ - $$))    db 0
dw 0xAA55

buffer:
