[bits 16]
[global _stage2_start]
[extern _stage2_32]

section .text

_stage2_start:
    mov si, stage2msg1
    call puts

    lgdt [GDT_Descriptor]       ; Load GDT

    in al, 0x92                 ; Enable A20 gate
    or al, 0x02
    out 0x92, al
    mov eax, cr0                ; Set the first bit in cr0 to 1
    or eax, 1
    mov cr0, eax                ; 32 bit protected mode

    CODE_SEG equ code_descriptor - GDT_Start
    DATA_SEG equ data_descriptor - GDT_Start

%ifdef BITS64

%endif

    jmp CODE_SEG:_stage2_32

    jmp $                       ; should never happen
    cli                         ; disable interrupts
    hlt                         ; this way CPU can't get out of "halt" state

%include "print_string.S"

section .data

stage2msg1: db "Got to stage 2 of the bootloader. (16 bits)", ENDL

GDT_Start:
    null_descriptor:
        dd  0
        dd  0
    code_descriptor:
        dw 0xffff
        dw 0                    ; 16 bits +
        db 0                    ; 8 bits = 24
        db 0b10011010           ; type flags
        db 0b11001111           ; other flags
        db 0                    ; last 8 bits of base
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
