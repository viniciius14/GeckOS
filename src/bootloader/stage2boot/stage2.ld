ENTRY(_stage2_16)
SECTIONS
{
    . = 0x7E00;

    .text :
    {
        *(_stage2_16.text)
        *(.text)
    } :text  /* Assign to 'text' PHDR */

    .data :
    {
        *(.data)
    } :data  /* Assign to 'data' PHDR */

    .bss :
    {
        *(.bss)
    } :bss  /* Assign to 'bss' PHDR */
}

PHDRS
{
    text PT_LOAD FLAGS(5);  /* R-X (Read + Execute) */
    data PT_LOAD FLAGS(6);  /* RW- (Read + Write)   */
    bss  PT_LOAD FLAGS(6);  /* RW- (Read + Write)   */
}
