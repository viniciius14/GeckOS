#ifndef GLOBAL_DESCRIPTOR_TABLE_H
#define GLOBAL_DESCRIPTOR_TABLE_H

/* --------------- Includes ---------------- */

#include "standard.h"

/* ---------------- Defines ---------------- */

/* None  */

/* ----------------- Types ----------------- */

typedef struct {
    Ushort size;
    Uint   base;
} PACKED GdtPtr;

/*
Base: A 32-bit value containing the linear address where the segment begins
Limit: A 20-bit value, tells the maximum addressable unit, either in 1 byte units, or in 4KiB pages.
Hence, if you choose page granularity and set the Limit value to 0xFFFFF the segment will span the
full 4 GiB address space in 32-bit mode.
*/

typedef struct {
    Ushort lowLimit;
    Uint   lowBase : 24;
    Ubyte  access;
    Ubyte  highLimit : 4;
    Ubyte  flags     : 4;
    Ubyte  highBase;
} PACKED GdtEntry;

/* ---------- Function prototypes ---------- */

void InitGdt(void);

#endif /* GLOBAL_DESCRIPTOR_TABLE_H */
