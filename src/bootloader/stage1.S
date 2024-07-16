[bits 16]

SECTION .text

%include "header.S"

KERNEL_LOAD_SEGMENT     equ 0x2000
KERNEL_LOAD_OFFSET      equ 0

_stage1_start:
    %ifdef DEBUG
        ; TBD: check that the value in CS is 0x7C00
        ; TBD: check that the value in DL is 0x80 for HDD or 0x00 for floppy
        ; TBD: check that the value in SP is 0x7C00
    %endif
    ; TBD: Remove me
    ; mov ah, 0x0E
    ; mov al, 'A'
    ; int 0x10

    cli
	mov ax, 0
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7C00

    ; pushf         ; push flags onto the stack
    ; pop ax        ; pop flags into ax
    ; or ax, 0400h  ; set direction flag
    ; push ax       ; push ax
    ; popf          ; pop into flags

    sti

    call fat_root_dir
    call search_kernel

    jmp KERNEL_LOAD_SEGMENT:KERNEL_LOAD_OFFSET

%include "boot_utils.S"
%include "find_root_dir.S"
%include "find_kernel.S"

SECTION .text
times (510 - ($ - $$))    db 0
dw 0xAA55

buffer:
