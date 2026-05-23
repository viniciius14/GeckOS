#ifndef PIC_H
#define PIC_H

/* --------------- Includes ---------------- */

#include "idt.h"
#include "io.h"

/* ---------------- Defines ---------------- */

#define PIC1_COMMAND (0x20)
#define PIC1_DATA    (0x21)
#define PIC2_COMMAND (0xA0)
#define PIC2_DATA    (0xA1)

#define PIC_EOI      (0x20)

/* ----------------- Types ----------------- */

/* None */

/* ---------- Function prototypes ---------- */

void InitPic(void);

void PicRemap(int offset1, int offset2);

/* Default handler that is triggered when an interrupt occurs */
void InterruptDispatcher(CpuState *cpuState);

void RegisterInterruptHandler(InterruptSourceE entry, HandlerFn handler);

void SendEOI(Ubyte vector);

#endif /* PIC_H */
