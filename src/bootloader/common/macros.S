%ifndef __MACROS_S
%define __MACROS_S

%macro unreachable 0
    cli             ; disable interrupts
    hlt             ; this way CPU can't get out of "halt" state
    jmp $
%endmacro

%endif
