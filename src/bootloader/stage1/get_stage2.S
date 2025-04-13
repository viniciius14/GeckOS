get_stage2:
    mov si, fileStage2Bin

%ifdef FAT_FS
    mov dx, [BS_DrvNum]

    call FAT_find_file

    xor bx, bx
    mov es, bx
    mov bx, STAGE2_OFFSET

    call FAT_load_chain

%endif

    print_letter "J"

    jmp STAGE2_SEGMENT:STAGE2_OFFSET

    jmp failure

%ifdef FAT_FS
    %include "FAT_utils.S"
%endif
