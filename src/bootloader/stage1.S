[bits 16]

[global _stage1_start]

SECTION .text

; Default FAT 12 header file size
%ifndef HEADER_SIZE
%define HEADER_SIZE 62
%endif

; starts at 0x7C00 + 0x3E
_stage1_start:
    %ifdef DEBUG
        ; TBD: check that the value in CS is 0x7C00
        ; TBD: check that the value in DL is 0x80 for HDD or 0x00 for floppy
        ; TBD: check that the value in SP is 0x7C00
    %endif

    ; TBD: Delete this
    mov ah, 0x0E
    mov al, 'A'
    int 0x10

    ; Clean out registers
    mov ax, 0

    mov bp, ax      ; base pointer register
    mov cs, ax      ; code segment register
    mov ds, ax      ; data segment register
    mov es, ax      ; extra segment register
    mov ss, ax      ; stack segment register
    mov si, ax      ; source index register             ; NOTE: Remove(?)
    mov di, ax      ; destination index register        ; NOTE: Remove(?)
    mov sp, 0x7C00  ; stack pointer register

    jmp fat_root_dir
    jmp search_kernel

    mov ah, 0x0E
    mov al, 'D'
    int 0x10

    jmp $

    ; jmp KERNEL_LOAD_SEGMENT:KERNEL_LOAD_OFFSET

%include "boot_utils.S"
%include "find_root_dir.S"
%include "find_kernel.S"

SECTION .text
times ((510 - HEADER_SIZE) - ($-$$))    db 0
dw 0xAA55
