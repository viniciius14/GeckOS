get_stage2:
    mov si, file_stage2_bin

%ifdef FAT_FS
    call FAT_find_file
%else
    %error "No support for finding files in the current filesystem."
%endif

    jc failure

    mov bx, STAGE2_OFFSET
    mov ax, STAGE2_SEGMENT
    mov es, ax
    mov dl, [BS_DrvNum]

%ifdef FAT_FS
    call FAT_load_file
%endif

    jc failure

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ah, 0x0E
    mov al, 'A'
    int 0x10
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    jmp STAGE2_SEGMENT:STAGE2_OFFSET

    jmp failure

%ifdef FAT_FS
    %include "FAT_utils.S"
%endif

