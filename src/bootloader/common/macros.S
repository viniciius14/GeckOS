%ifndef __UTILS_S
%define __UTILS_S

%macro unreachable 0
    cli             ; disable interrupts
    hlt             ; this way CPU can't get out of "halt" state
    jmp $
%endmacro

%endif
