%ifndef __DEFINES_S
%define __DEFINES_S

%ifdef FAT12
    %define FAT_FS
%elifdef FAT_16
    %define FAT_FS
%elifdef FAT_32
    %define FAT_FS
%else
    %error "No filesystem defined or the defined filesystem is not supported."
%endif

%endif
