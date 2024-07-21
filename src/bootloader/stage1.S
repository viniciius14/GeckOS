[bits 16]

; TODO; Change this value, here for error throwing purposes
%ifndef RESERVED_SECTORS
%define RESERVED_SECTORS -1
%endif

%include "header.S"

SECTION .text

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

	mov ax, 0
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7C00

    call load_stage_2   ; put stage2 of bootloader into RAM address 0x7E00

    jmp S2_LOAD_SEGMENT:S2_LOAD_OFFSET

%include "boot_utils.S"
%include "load_stage2.S"

SECTION .text
times (510 - ($ - $$))    db 0
dw 0xAA55

buffer:
