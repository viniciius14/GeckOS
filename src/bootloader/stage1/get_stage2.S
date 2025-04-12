get_stage2:
    mov si, fileStage2Bin

%ifdef FAT_FS
    mov dl, [BS_DrvNum]

    call FAT_find_file

    jc failure

    mov si, STAGE2_OFFSET
    mov bx, STAGE2_SEGMENT
    mov ds, bx

    call FAT_load_chain

    jc failure
%endif


    jmp STAGE2_SEGMENT:STAGE2_OFFSET

    jmp failure

%ifdef FAT_FS
    %include "FAT_utils.S"
%endif
