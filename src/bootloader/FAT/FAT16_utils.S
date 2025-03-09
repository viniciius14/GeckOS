%ifndef __FAT16_UTILS_S
%define __FAT16_UTILS_S

%include "disk.S"

section .text

loadStage2:
;     mov ax, 1
;     mov cl, 1
;     mov dl, [BS_DrvNum]
;     call disk_read
;     jmp S2_LOAD_SEGMENT:S2_LOAD_OFFSET

    ; Setup to call disk_read
    mov ax, 1                       ; LBA Address
    mov cl, 1  ; Number of sectors
    mov dl, [BS_DrvNum]
    mov bx, buffer

    ; Load stage2 of the bootloader into RAM address 0x7E00
    call disk_read
    jmp S2_LOAD_SEGMENT:S2_LOAD_OFFSET

    jmp $             ; should never happen

    cli                                 ; disable interrupts, this way CPU can't get out of "halt" state
    hlt


%endif
