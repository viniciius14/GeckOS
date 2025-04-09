%ifndef __FAT32_UTILS_S
%define __FAT32_UTILS_S

loadStage2:
    ; Setup to call BIOS_read
    mov ax, 2                   ; LBA Address
    mov cl, 1                   ; Number of sectors
    mov dl, [BS_DrvNum]
    mov bx, STAGE2_BUFFER_START
    call BIOS_read              ; Load stage2 to RAM address 0x7E00

    jmp STAGE2_BUFFER_SEGMENT:STAGE2_BUFFER_START

    jmp $                       ; should never happen
    cli                         ; disable interrupts
    hlt                         ; this way CPU can't get out of "halt" state

%endif
