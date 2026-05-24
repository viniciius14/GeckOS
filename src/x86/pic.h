#ifndef PIC_H
#define PIC_H

/* --------------- Includes ---------------- */

#include "idt.h"
#include "io.h"
#include "strings.h"

/* ---------------- Defines ---------------- */

#define PIC1_COMMAND (0x20)
#define PIC1_DATA    (0x21)
#define PIC2_COMMAND (0xA0)
#define PIC2_DATA    (0xA1)

#define PIC_EOI      (0x20)

/* ----------------- Types ----------------- */

/* Interrupt frame to pass to interrupt handlers */
/* @TODO: Rename me / not is use atm */
typedef struct {
    Uint eip;
    Uint cs;
    Uint eFlags;
    // The following are only valid if a privilege switch occurred:
    Uint userEsp;
    Uint UserSs;
} PACKED InterruptState;

typedef struct {
    Uint ds;
    Uint edi, esi, ebp, esp, ebx, edx, ecx, eax; // GPRs
    Uint vector, errorCode;
    // Pushed by the CPU hardware
    InterruptState intState;
} PACKED CpuState;

typedef void (*HandlerFn)(CpuState *);
typedef enum { E_PIC_INT = 0 } InterruptSourceE;

/* ---------- Function prototypes ---------- */

void InitPic(void);

void PicRemap(int offset1, int offset2);

/* Default handler that is triggered when an interrupt occurs */
void InterruptDispatcher(CpuState *cpuState);

void RegisterInterruptHandler(InterruptSourceE entry, HandlerFn handler);

void SendEOI(Ubyte vector);

#endif /* PIC_H */
