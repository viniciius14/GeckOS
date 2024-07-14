SECTIONS {
    . = 0x7C00;
    .text   : { *(.text)    }
    .rodata : { *(.rodata)  }
    .data   : { *(.data)    }
    .bss    : { *(.bss)     }
}

/*
SECTIONS
{
    . = 0x7C00;

    .text BLOCK(4K) : ALIGN(4K)
    {
        *(.text)
    }

    .rodata BLOCK(4K) : ALIGN(4K)
    {
        *(.rodata)
    }

    .data BLOCK(4K) : ALIGN(4K)
    {
        *(.data)
    }

    .bss BLOCK(4K) : ALIGN(4K)
    {
        *(.bss)
    }

}
 */
