%ifndef __SET_GDT_S
%define __SET_GDT_S

; @TODO: Find a way to get the .c defines into .S files
%define GDT_KERNEL_CODE_SEG (0x8)
%define GDT_KERNEL_DATA_SEG (0x10)

global setGDT

extern gdtPtr

setGDT:
   mov   ax, [esp + 4]
   mov   [gdtPtr], ax
   mov   eax, [esp + 8]
   mov   [gdtPtr + 2], eax
   lgdt  [gdtPtr]

.reloadSegments:
   jmp   GDT_KERNEL_CODE_SEG:.reloadCS ; 0x08-> kernel code segment

.reloadCS:
   mov   ax, GDT_KERNEL_DATA_SEG ; 0x10 -> kernel data segment
   mov   ds, ax
   mov   es, ax
   mov   fs, ax
   mov   gs, ax
   mov   ss, ax
   ret

%endif
