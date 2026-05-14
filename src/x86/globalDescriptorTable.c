/* --------------- Includes ---------------- */

#include "globalDescriptorTable.h"

/* ---------- Function Prototypes ---------- */

extern void setGDT(Ushort size, Uint base);

/* ----------- Global Variables ------------ */

#define GDT_KERNEL_CODE_SEG (0b1 << 3)
#define GDT_KERNEL_DATA_SEG (0b11 << 3)
#define GDT_USER_CODE_SEG   (0b111 << 3)
#define GDT_USER_DATA_SEG   (0b111 << 3)

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

/* @TODO: Confirm this function is being inlined */
INLINE void InitGdt(void) {
    setGDT(sizeof(globalDescriptorTable) - 1, (Uint)&globalDescriptorTable[0]);
}
