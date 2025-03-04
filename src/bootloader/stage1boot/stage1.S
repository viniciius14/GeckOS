[bits 16]

%define S2_LOAD_SEGMENT 0x0
%define S2_LOAD_OFFSET  0x7E00

%ifdef FAT_12
    %include "FAT_header.S"
    %include "FAT12_utils.S"
%elifdef FAT_16
    %include "FAT_header.S"
    %include "FAT16_utils.S"
%elifdef FAT_32
    %include "FAT_header.S"
    %include "FAT32_utils.S"
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

    push es             ; Some BIOSes might start us at 07C0:0000 instead of 0000:7C00
    push word .gotoStage2
    retf


; Find stage 2 of the bootloader and load it into memory
.gotoStage2:
    jmp loadStage2

    jmp S2_LOAD_SEGMENT:S2_LOAD_OFFSET

times (510 - ($ - $$)) db 0
dw 0xAA55

