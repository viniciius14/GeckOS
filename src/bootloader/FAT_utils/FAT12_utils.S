%ifndef __FAT12_UTILS_S
%define __FAT12_UTILS_S

section .text

    loadStage2:
    ; go to root directory (can get that info by using offsets from 0x7C00 or by re reading the first sector)
    ; find boot.bin (max 11 characters !)
    ; load it into 0x7e00
    ; jump to it
    jmp $

%endif
