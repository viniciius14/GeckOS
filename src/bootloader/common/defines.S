%ifndef __DEFINES_S
%define __DEFINES_S

; Checks for conflicting defines
%ifdef BITS32
    %ifdef BITS64
        %error "Conflicting flags defined."
    %endif
%endif

%ifdef FAT12
    %define FAT_FS
%elifdef FAT16
    %define FAT_FS
%elifdef FAT32
    %define FAT_FS
%else
    %error "No filesystem defined or the defined filesystem is not supported."
%endif

; Checks for get_stage2 part of the code
%ifndef FAT_FS
    %error "No support for finding files in the current filesystem."
%endif

%endif
