#ifndef INTERRUPT_DESCRIPTOR_TABLE_H
#define INTERRUPT_DESCRIPTOR_TABLE_H

/* --------------- Includes ---------------- */

#include "gdt.h"
#include "io.h"
#include "standard.h"
#include "strings.h"

/* ---------------- Defines ---------------- */

#define TRAP_GATE_FLAGS (0x8F)
#define INT_GATE_FLAGS  (0x8E)
#define SIZEOF_IDT      (256)
#define PIC1_COMMAND    (0x20)
#define PIC_EOI         (0x20)
#define IRQ_BASE_OFFSET (32)

/* ----------------- Types ----------------- */

/* Entry for the IDT */
typedef struct {
    Ushort isrLow;
    Ushort kernelCS;
    Ubyte  reserved;
    Ubyte  attributes;
    Ushort isrHigh;
} PACKED IdtEntry;

/* IDT pointer to be passed into lidt instruction */
typedef struct {
    Ushort limit;
    Uint   base;
} PACKED IdtPtr;

/* Interrupt frame to pass to interrupt handlers */
/* @TODO: Rename me */
typedef struct {
    Uint eip;
    Uint cs;
    Uint eFlags;
    // The following are only valid if a privilege switch occurred:
    Uint userEsp;
    Uint UserSs;
} PACKED InterruptState;

typedef struct {
    // Pushed by your assembly stub (InterruptRouter)
    Uint ds;
    Uint edi, esi, ebp, esp, ebx, edx, ecx, eax; // GPRs
    Uint vector, errorCode;
    // Pushed by the CPU hardware
    InterruptState intState;
} PACKED CpuState;

typedef void (*HandlerFn)(CpuState *);

/* ---------- Function prototypes ---------- */

/* Initializes the interrupt descriptor table */
void InitIdt(void);

/* Add an ISR to the IDT */
void IdtSetDescriptor(Ubyte entryNumber, HandlerFn isr, Ubyte flags);

/* Default handler that is triggered when an interrupt occurs */
void InterruptDispatcher(CpuState *cpuState);

/* Default handler that is triggered when an exception without an error code occurs */
void DftExcpHandler(CpuState *cpuState);

/* Default handler that is triggered when an exception with an error code occurs  */
void DftExcpHandlerError(CpuState *cpuState, Uint errorCode);

extern void PicIntHandler(CpuState *intStack);

void RegisterInterruptHandler(Ushort entry, HandlerFn handler);

void SendEOI(Ubyte vector);

#endif /* INTERRUPT_DESCRIPTOR_TABLE_H */
