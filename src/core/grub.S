BITS 32

%ifdef GRUB

section .text
    align 4
    dd 0x1BADB002 ; Magic number
    dd 0x00000003 ; Flags
    dd -(0x1BADB002 + 0x00000003) ; Checksum

%endif
 