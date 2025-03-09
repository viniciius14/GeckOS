%ifndef __FAT32_UTILS_S
%define __FAT32_UTILS_S

%include "disk.S"

section .text

loadStage2:
    ; Setup to call disk_read
    mov ax, 2                       ; LBA Address
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
