[bits 16]
[global _stage2_start]
[extern _stage2_32]

section .text

%define ENDL 0x0D, 0x0A

; TODO:
;   - BIOS ints
;   - Unload Stage 1 from RAM
;   - Load GDT
;   - Load IDT
;   - Video mode and resolution -> VESA
;   - Sound (?)
;   - Clear stack, registers etc

_stage2_start:
    mov [bdb_sectors_per_track], ax
    mov [bdb_heads], bx


    mov si, msg_hello
    call put_str

    ;
    ; Load GDT
    lgdt [GDT_Descriptor]
    ;
    CODE_SEG equ code_descriptor - GDT_Start
    DATA_SEG equ data_descriptor - GDT_Start

    ; Switches to graphics mode 0x13 -> Resolution: 320 x 200 | Adapter: EGA | Colors: 16 bit
    ; mov ah, 0x0
    ; mov al, 0x13
    ; int 0x10


    ; Switches to text mode and as a result clears the screen
    mov ah, 0x0
    mov al, 0x3
    int 0x10
    mov si, msg_hello
    call put_str

    in al, 0x92             ; Enable A20 gate
    or al, 0x02
    out 0x92, al

    mov eax, cr0
    or eax, 1
    mov cr0, eax            ; 32 bit protected mode

    mov ax, CODE_SEG    ; "send" CODE_SEG to stage2_32.S

    jmp CODE_SEG:_stage2_32

    jmp $

%include "boot_utils.S"


section .data

bdb_sectors_per_track:      dw 0
bdb_heads:                  dw 0



msg_hello: db 'Hello world from STAGE TWO BOOTLOADER!', ENDL,  0


GDT_Start:
    null_descriptor:
        dd  0
        dd  0
    code_descriptor:
        dw 0xffff
        dw 0            ; 16 bits +
        db 0            ; 8 bits = 24
        db 0b10011010   ; type flags
        db 0b11001111   ; other flags
        db 0            ; last 8 bits of base
    data_descriptor:
        dw 0xffff
        dw 0
        db 0
        db 0b10010010
        db 0b11001111
        db 0
GDT_End:

GDT_Descriptor:
    dw GDT_End - GDT_Start - 1  ; size
    dd GDT_Start                ; start

