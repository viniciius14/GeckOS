/* --------------- Includes ---------------- */

#include "globalDescriptorTable.h"

/* ---------- Function Prototypes ---------- */

/* None */

/* ----------- Global Variables ------------ */

/* None */

/* -------- Function Implementations ------- */

Ubyte myByte = 0;

const GdtEntry globalDescriptorTable[] = {
    /* Null Descriptor */
    {
        .lowLimit  = 0,
        .lowBase   = 0,
        .access    = 0,
        .highLimit = 0,
        .flags     = 0,
        .highBase  = 0,
    },
    /* Kernel Code Segment */
    {
        .lowLimit  = 0xFFFF,
        .lowBase   = 0,
        .access    = 0x9A,
        .highLimit = 0xF,
        .flags     = 0xC,
        .highBase  = 0,
    },
    /* Kernel Data Segment */
    {
        .lowLimit  = 0xFFFF,
        .lowBase   = 0,
        .access    = 0x92,
        .highLimit = 0xF,
        .flags     = 0xC,
        .highBase  = 0,
    },
    /* User Code Segment */
    {
        .lowLimit  = 0xFFFF,
        .lowBase   = 0,
        .access    = 0xFA,
        .highLimit = 0xF,
        .flags     = 0xC,
        .highBase  = 0,
    },
    /* User Data Segment */
    {
        .lowLimit  = 0xFFFF,
        .lowBase   = 0,
        .access    = 0xF2,
        .highLimit = 0xF,
        .flags     = 0xC,
        .highBase  = 0,
    },
#if 0
    /* @TODO */
    /* Task State Segment */
    {
        .lowLimit  = 0,
        .lowBase   = 0,
        .access    = 0,
        .highLimit = 0,
        .flags     = 0,
        .highBase  = 0
    }
#endif
};

const GdtPtr tablePtr = {
    .base = (Uint)&globalDescriptorTable[0],
    .size = sizeof(globalDescriptorTable) / sizeof(GdtEntry),
};

void InitGdt(void) {
    ASM("lgdt %0" : : "memory"(tablePtr));
}
