OUTPUT_FORMAT(elf32-i386)
ENTRY(_stage2_start)

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

    /DISCARD/ :
    {
        *(.note.*)
        *(.comment)
    }
}

PHDRS
{
    text PT_LOAD FLAGS(5);  /* R-X (Read + Execute) */
    data PT_LOAD FLAGS(6);  /* RW- (Read + Write)   */
    bss PT_LOAD FLAGS(6);   /* RW- (Read + Write)   */
}