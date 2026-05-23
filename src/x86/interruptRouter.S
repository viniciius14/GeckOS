%ifndef __INTERRUPT_ROUTER_S
%define __INTERRUPT_ROUTER_S

section .text

global isrStubTable

extern InterruptDispatcher

%macro ISR_WITH_ERR 1
global _isr%1
_isr%1:
                ; (The CPU already pushed the error code here)
    push %1     ; Push the interrupt number
    jmp InterruptRouter
%endmacro

%macro ISR_NO_ERR 1
global _isr%1
_isr%1:
    push 0          ; Push a dummy error code to keep stack consistent
    push %1         ; Push the actual interrupt number (the vector!)
    jmp InterruptRouter
%endmacro

InterruptRouter:
    pusha           ; Save all registers (EAX, ECX, etc.)

    mov ax, ds      ; Save the Data Segment
    push eax

    mov ax, 0x10    ; Load the Kernel Data Segment
    mov ds, ax
    mov es, ax

    push esp        ; Push the stack pointer (this becomes our InterruptState*)
    call InterruptDispatcher
    add esp, 4      ; Clean up the pushed stack pointer

    pop eax         ; Restore original Data Segment
    mov ds, ax
    mov es, ax

    popa            ; Restore all registers
    add esp, 8      ; Clean up the vector number and dummy error code

    iret            ; Return from interrupt


; Define all the interrupt stubs
ISR_NO_ERR 0
ISR_NO_ERR 1
ISR_NO_ERR 2
ISR_NO_ERR 3
ISR_NO_ERR 4
ISR_NO_ERR 5
ISR_NO_ERR 6
ISR_NO_ERR 7
ISR_WITH_ERR 8
ISR_NO_ERR 9
ISR_WITH_ERR 10
ISR_WITH_ERR 11
ISR_WITH_ERR 12
ISR_WITH_ERR 13
ISR_WITH_ERR 14
ISR_NO_ERR 15
ISR_NO_ERR 16
ISR_WITH_ERR 17
ISR_NO_ERR 18
ISR_NO_ERR 19
ISR_NO_ERR 20
ISR_WITH_ERR 21

; @TODO: Verify this comment + improve it
; From 21 - 32 it's exception without and opcode
; From 32 - 255 it's interrupts
%assign i 22
%rep (256 - 22)
    ISR_NO_ERR i
    %assign i i+1
%endrep

section .data
align 16

isrStubTable:
%assign i 0
%rep 256
    dd _isr%+i    ; This stores the ADDRESS of the code in the table
    %assign i i+1
%endrep

%endif
