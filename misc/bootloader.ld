ENTRY(_stage2_start)
SECTIONS
{
  . = 0x7E00;
  .text :
  {
    *(.text)
  }
  /* . = ALIGN(4K); */
  .rodata :
  {
    *(.rodata)
  }
  .data :
  {
    *(.data)
  }
  .bss :
  {
    *(.bss)
  }
}
