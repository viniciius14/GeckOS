[bits 16]

SECTION .text

%define ENDL 0x0D, 0x0A

_kernel_start:
    jmp $



msg_hello: db 'Hello world from KERNEL!', ENDL,  0