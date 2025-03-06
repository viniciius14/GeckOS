[bits 16]
[org 0x7C00]

%define S2_LOAD_SEGMENT 0x0
%define S2_LOAD_OFFSET  0x7E00

%ifdef FAT_12
    %include "FAT_header.S"
%elifdef FAT_16
    %include "FAT_header.S"
%elifdef FAT_32
    %include "FAT_header.S"
%endif


_stage1_start:
    mov ah, 0xE
    mov al, 'H'
    int 0x10
    mov ah, 0xE
    mov al, 'e'
    int 0x10
    mov ah, 0xE
    mov al, 'l'
    int 0x10
    mov ah, 0xE
    mov al, 'l'
    int 0x10
    mov ah, 0xE
    mov al, 'o'
    int 0x10
    mov ah, 0xE
    mov al, '!'
    int 0x10

    cli                 ; Clear interrupt flag
    cld                 ; Clear direction flag
	xor ax, ax          ; Clear main registers
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7C00

    jmp gotoStage2

; Find stage 2 of the bootloader and load it into memory
gotoStage2:
    jmp loadStage2


%ifdef FAT_12
    %include "FAT12_utils.S"
%elifdef FAT_16
    %include "FAT16_utils.S"
%elifdef FAT_32
    %include "FAT32_utils.S"
%endif

times (510 - ($ - $$)) db 0
dw 0xAA55

buffer:
