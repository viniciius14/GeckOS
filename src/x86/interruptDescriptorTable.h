#ifndef INTERRUPT_DESCRIPTOR_TABLE_H
#define INTERRUPT_DESCRIPTOR_TABLE_H

/* --------------- Includes ---------------- */

#include "io.h"
#include "standard.h"
#include "strings.h"

/* ---------------- Defines ---------------- */

#define TRAP_GATE_FLAGS  (0x8F)
#define INT_GATE_FLAGS   (0x8E)
#define SIZEOF_IDT       (256)
#define PIC1_COMMAND     (0x20)
#define PIC_EOI          (0x20)
#define INT_START_OFFSET (32)

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
typedef struct {
    Uint eip;
    Uint cs;
    Uint eFlags;
    Uint sp;
    Uint ss;
} PACKED IntFrame;

typedef struct {
    Uint     ds;                                     /* Data segment selector */
    Uint     edi, esi, ebp, esp, ebx, edx, ecx, eax; /* Pushed by pusha */
    Uint     intNb, errCode;                         /* Pushed by us */
    IntFrame intFrame;                               /* Pushed by CPU automatically */
} PACKED InterruptStack;

typedef void (*IsrFnPtr)(void);

/* ---------- Function prototypes ---------- */

/* Initializes the interrupt descriptor table */
void InitIdt(void);

/* Add an ISR to the IDT */
void IdtSetDescriptor(Ubyte entryNumber, IsrFnPtr isr, Ubyte flags);

/* Default handler that is triggered when an interrupt occurs */
void DftIntHandler(InterruptStack *intStack) INTERRUPT;

/* Default handler that is triggered when an exception without an error code occurs */
void DftExcpHandler(IntFrame *frame) INTERRUPT;

/* Default handler that is triggered when an exception with an error code occurs  */
void DftExcpHandlerError(IntFrame *frame, Uint errorCode);

#endif /* INTERRUPT_DESCRIPTOR_TABLE_H */
