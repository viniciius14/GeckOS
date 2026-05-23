#ifndef PIT_H
#define PIT_H

/* --------------- Includes ---------------- */

#include "idt.h"
#include "pic.h"

/* ---------------- Defines ---------------- */

#define PIT_COMMAND (0x43)
#define PIT_DATA0   (0x40)

// The oscillator frequency of the internal PIT chip
#define PIT_BASE_FREQUENCY (1193182)

/* ----------------- Types ----------------- */

/* None */

/* ---------- Function prototypes ---------- */

void InitPit(Uint frequency);

#endif /* PIT_H */
