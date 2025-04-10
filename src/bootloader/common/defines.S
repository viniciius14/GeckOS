%ifndef __DEFINES_S
%define __DEFINES_S

%assign FS_COUNT 0

; Checks for conflicting defines
%ifdef BITS32
    %ifdef BITS64
        %error "Conflicting flags defined."
    %endif
%endif

; Checks for conflicting defines
%ifdef FAT12
    %assign FS_COUNT FS_COUNT + 1
%elifdef FAT16
    %assign FS_COUNT FS_COUNT + 1
%elifdef FAT32
    %assign FS_COUNT FS_COUNT + 1
%endif

%if FS_COUNT = 0
    %error "No filesystem type defined."
%elif FS_COUNT > 1
    %error "Conflicting filesystem types defined. Define only 1."
%endif

; Composite defines
%ifdef FAT12
    %define FAT_FS
%elifdef FAT16
    %define FAT_FS
%elifdef FAT32
    %define FAT_FS
%endif

%endif
