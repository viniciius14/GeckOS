%ifndef __INT_STUBS_S
%define __INT_STUBS_S

extern DftIntHandler

%macro ISR_NOERRCODE 1
global isr%1
isr%1:
    push 0          ; Push a dummy error code to keep stack consistent
    push %1         ; Push the actual interrupt number (the vector!)
    jmp commonIntStub
%endmacro

%assign i 32
%rep (256 - 32)
    ISR_NOERRCODE i
    %assign i i+1
%endrep

; Create stubs for the ones you care about (e.g., 32 and 33)
; ISR_NOERRCODE 32
; ISR_NOERRCODE 33
; ... you can automate this with a loop in nasm or just list them

commonIntStub:
    pusha           ; Save all registers (EAX, ECX, etc.)

    mov ax, ds      ; Save the Data Segment
    push eax

    mov ax, 0x10    ; Load the Kernel Data Segment
    mov ds, ax
    mov es, ax

    push esp        ; Push the stack pointer (this becomes our IntFrame*)
    call DftIntHandler
    add esp, 4      ; Clean up the pushed stack pointer

    pop eax         ; Restore original Data Segment
    mov ds, ax
    mov es, ax

    popa            ; Restore all registers
    add esp, 8      ; Clean up the vector number and dummy error code
    iret            ; Return from interrupt

%endif



; _isr32:
;     push %someAddress
;     jmp commonIntHeader
;     ...
;     call [esp - N]
;     ...
;     pop ; someAddress
;     iret


; call [esp - N]:
; void isr32(InterruptStack *intStack)

