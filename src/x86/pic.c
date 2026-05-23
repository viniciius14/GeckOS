/* --------------- Includes ---------------- */

#include "pic.h"

/* ---------- Function Prototypes ---------- */

/* None */

/* ----------- Global Variables ------------ */

/* None */

/* -------- Function Implementations ------- */

void PicRemap(void) {
    // ICW1: Start initialization
    OutByte(0x20, 0x11);
    OutByte(0xA0, 0x11);

    // ICW2: Set vector offsets (0x20 = 32 decimal)
    OutByte(0x21, 0x20); // Master PIC starts at 32
    OutByte(0xA1, 0x28); // Slave PIC starts at 40

    // ICW3: Tell Master PIC there is a slave PIC at IRQ2
    OutByte(0x21, 0x04);
    OutByte(0xA1, 0x02);

    // ICW4: Set 8086 mode
    OutByte(0x21, 0x01);
    OutByte(0xA1, 0x01);

    // Mask all interrupts until we are ready
    OutByte(0x21, 0x00);
    OutByte(0xA1, 0x00);
}
