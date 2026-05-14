#ifndef PIT_H
#define PIT_H

/* --------------- Includes ---------------- */

#include "idt.h"

/* ---------------- Defines ---------------- */

/* None */

/* ----------------- Types ----------------- */

/* None */

/* ---------- Function prototypes ---------- */

void PicIntHandler(CpuState *intStack);

#endif /* PIT_H */
