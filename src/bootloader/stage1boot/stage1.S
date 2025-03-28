[bits 16]
[org 0x7C00]

%define S2_LOAD_SEGMENT 0x0
%define S2_LOAD_OFFSET  0x7E00

%ifdef  FAT12
    %include "FAT_header.S"
%elifdef  FAT16
    %include "FAT_header.S"
%elifdef  FAT32
    %include "FAT_header.S"
%else
    %error "No filesystem type defined."
%endif

%include "macros.S"

_stage1_start:
    ; Clear the screen
    ; Switches to text mode
    mov ah, 0x0
    mov al, 0x3
    int 0x10

    ; Switches to graphics mode 0x13 -> Resolution: 320 x 200 | Adapter: EGA | Colors: 16 bit
    ; mov ah, 0x0
    ; mov al, 0x13
    ; int 0x10

    cli                 ; Clear interrupt flag
    cld                 ; Clear direction flag
    xor ax, ax          ; Clear main registers
    mov bx, ax
    mov cx, ax
    mov dx, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Find stage 2 of the bootloader and load it into memory
    jmp loadStage2

    unreachable

%ifdef  FAT12
    %include "FAT12_utils.S"
%elifdef  FAT16
    %include "FAT16_utils.S"
%elifdef  FAT32
    %include "FAT32_utils.S"
%endif

times (510 - ($ - $$)) db 0
dw 0xAA55

%ifdef  FAT32
    %include "FSInfo_FAT32.S"
%endif

buffer:
