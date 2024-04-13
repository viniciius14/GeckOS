org 0x7C00
bits 16

.Bootloader:




times 510-($-$$) db 0
db 0x55, 0xAA