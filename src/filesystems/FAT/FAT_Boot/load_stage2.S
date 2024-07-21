%ifndef LOAD_STAGE2_S_
%define LOAD_STAGE2_S_

[bits 16]

SECTION .text

load_stage_2:
    ; Setup to call disk_read
    mov ax, 1
    mov cl, (RESERVED_SECTORS - 1)
    mov dl, [ebr_drive_number]
    mov bx, S2_LOAD_OFFSET

    call disk_read

    mov si, disk_read_msg
    call put_str

    ret

disk_read_msg: db "Disk Read!", ENDL, 0

%endif