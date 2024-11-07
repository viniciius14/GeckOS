[bits 16]

[global _stage2_start]

[extern _stage2_32]

%define ENDL 0x0D, 0x0A

section .text

; TODO:
;   - BIOS ints
;   - Unload Stage 1 from RAM
;   - Load GDT
;   - Load IDT
;   - Video mode and resolution -> VESA
;   - Sound (?)
;   - Clear stack, registers etc

_stage2_start:
    lgdt [GDT_Descriptor]       ; Load GDT

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

    in al, 0x92             ; Enable A20 gate
    or al, 0x02
    out 0x92, al

    mov eax, cr0            ; Set the first bit in cr0 to 1
    or eax, 1
    mov cr0, eax            ; 32 bit protected mode

    jmp CODE_SEG:_stage2_32

    hlt

section .data

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
