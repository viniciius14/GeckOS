ENTRY(_kernel_main)
SECTIONS
{
  . = 0x1000000;
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
