ENTRY(_stage2_16)

SECTIONS
{
    . = 0x7E00;

    .text :
    {
        *(.text)
    } :text

    .data :
    {
        *(.data)
    } :data

    .bss :
    {
        *(COMMON)
        *(.bss)
    } :bss
}

PHDRS
{
    text PT_LOAD FLAGS(5);  /* R-X (Read + Execute) */
    data PT_LOAD FLAGS(6);  /* RW- (Read + Write)   */
    bss PT_LOAD FLAGS(6);   /* RW- (Read + Write)   */
}
