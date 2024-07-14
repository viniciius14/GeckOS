; Stage 2 of the bootloader
[bits 16]
[global _stage2_start]
[extern _kernel_start]

_stage2_start:
    cli                     ; disable all interrupts

    ; save boot drive
    ; mov [g_BootDrive], dl
    ; mov [g_BootPartitionOff], si
    ; mov [g_BootPartitionSeg], di

    ; setup stack
    ; mov esp, kernel_stack + KERNEL_STACK_SIZE
    ; mov ax, ds
    ; mov ss, ax
    ; mov sp, 0xFFF0
    ; mov bp, sp

    in al, 0x92             ; Enable A20 gate
    or al, 0x02
    out 0x92, al

    lgdt [GDT_Descriptor]   ; load GDT

    mov eax, cr0
    or eax, 1
    mov cr0, eax            ; 32 bit protected mode

    ; Switch to graphics mode or to text mode
    ; Text mode
    ; mov ah, 0x0
    ; mov al, 0x3
    ; int 0x10

    ; mov ah, 0x0E        ; call bios interrupt
    ; mov al, 'A'           ; set page number to 0
    ; int 0x10

    ; Graphics mode
    ; mov ah, 0x0
    ; mov al, 0x13
    ; int 0x10

    CODE_SEG equ code_descriptor - GDT_Start
    DATA_SEG equ data_descriptor - GDT_Start

    ; mov ah, 0x0E        ; call bios interrupt
    ; mov al, 'B'           ; set page number to 0
    ; int 0x10


    jmp _kernel_start
    ; jmp CODE_SEG:start_protected_mode  ; far jump (to another segment)
    jmp dword 08h:.start_protected_mode

    jmp $




[bits 32]
.start_protected_mode:
    mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000		; 32 bit stack base pointer
	mov esp, ebp

    jmp _kernel_start

    jmp $

; ; only to be loaded in 32 bit mode
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


g_BootDrive: db 0
g_BootPartitionSeg: dw 0
g_BootPartitionOff: dw 0


KERNEL_STACK_SIZE equ 4096                  ; size of stack in bytes




; section .bss
; ; [align 4]                                     ; align at 4 bytes
; kernel_stack:                               ; label points to beginning of memory
;     resb KERNEL_STACK_SIZE                  ; reserve stack for the kernel