%ifndef __CONSTANTS_S
%define __CONSTANTS_S

%ifdef FAT_FS
    FAT_BUFFER          equ 0x00500
    ROOT_DIR_BUFFER     equ 0x07E00
%endif

STAGE2_STACK            equ 0x07C00

STAGE2_OFFSET           equ 0x07E00
STAGE2_SEGMENT          equ 0x00000

KERNEL_BUFFER_START     equ 0x6F000
KERNEL_BUFFER_END       equ 0x7F000

KERNEL_START            equ 0x100000

%endif
