## boot_sector.S

Line 52-55
push es: This instruction saves the current value of the es segment register onto the stack. This is done to preserve its value before modifying it.

push word .after: This instruction pushes the address of the label .after onto the stack. This address will be used as the return address when control is transferred back to the main boot loader code.

retf: This instruction performs a far return. It pops an address off the stack (the return address) and transfers control to that address. Because this is a far return (retf), it also pops a new value from the stack and loads it into the cs register, effectively changing the code segment. In this case, the return address is the original instruction pointer (the address of .after) and the new code segment is 0000.

labels with a . beforehand mean that they are local to that file/scope