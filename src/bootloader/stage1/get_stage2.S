get_stage2:
    mov si, file_stage2_bin

%ifdef FAT_FS
    call FAT_find_file
%endif

    jc failure

    mov si, STAGE2_OFFSET
    mov ax, STAGE2_SEGMENT
    mov ds, ax
    mov dl, [BS_DrvNum]

%ifdef FAT_FS
    call FAT_load_file
%endif

    jc failure

    jmp STAGE2_SEGMENT:STAGE2_OFFSET

    jmp failure

%ifdef FAT_FS
    %include "FAT_utils.S"
%endif

