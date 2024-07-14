MEMORY
{
    rom (rx) : ORIGIN = 0x7C00 + __HEADER_SIZE__, LENGTH = 8K
}

SECTIONS
{
    . = 0x7C00 + __HEADER_SIZE__;

    .text :
    {
        _start = .;    /* This will be the entry point */
        *(.text)       /* All .text sections from input files */
        *(.rodata)     /* All .rodata sections from input files */
        _etext = .;    /* End of text section */
    } > rom

    .data :
    {
        _sdata = .;    /* Start of data section */
        *(.data)       /* All .data sections from input files */
        _edata = .;    /* End of data section */
    } > rom

    .bss :
    {
        _sbss = .;     /* Start of bss section */
        *(.bss)        /* All .bss sections from input files */
        _ebss = .;     /* End of bss section */
    } > rom

    _end = .;          /* End of all sections */
}
