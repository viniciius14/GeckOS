%ifndef __CONSTANTS_S
%define __CONSTANTS_S

; FAT related constants
FAT_BUFFER              equ 0x00500
ROOT_DIR_BUFFER         equ 0x07E00
FILE_NAME_SIZE          equ 11
DIR_ENTRY_SIZE          equ 32
CLUSTER_LOW_OFFSET      equ 26

%ifdef FAT12               ; BPB_RsvdSecCnt + (BPB_NumFATs * BPB_FATSz16) + ((BPB_RootEntCnt * 32) + BPB_BytsPerSec - 1) / BPB_BytsPerSec
    FAT_DATA_START      equ (0x1 + (0x2 * 0x9) + ((0xE * 32) + 0x200 - 1) / 200)
%elifdef FAT16             ; BPB_RsvdSecCnt + (BPB_NumFATs * BPB_FATSz16) + ((BPB_RootEntCnt * 32) + BPB_BytsPerSec - 1) / BPB_BytsPerSec
    FAT_DATA_START      equ (0x4 + (0x2 * 0x86) + ((0x200 * 32) + 0x200 -1) / 200)
    FAT_ENTRY_SIZE      equ 2
%elifdef FAT32             ; BPB_RsvdSecCnt + (BPB_NumFATs * BPB_FATSz32)
    FAT_DATA_START      equ (0x20 + (0x2 * 0x214))
    FAT_ENTRY_SIZE      equ 4
%endif


STAGE2_STACK            equ 0x07C00

STAGE2_OFFSET           equ 0x07E00
STAGE2_SEGMENT          equ 0x00000

KERNEL_BUFFER_START     equ 0x6F000
KERNEL_BUFFER_END       equ 0x7F000

KERNEL_START            equ 0x100000

%endif
