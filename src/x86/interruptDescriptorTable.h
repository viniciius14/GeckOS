#ifndef __INTERRUPT_DESCRIPTOR_TABLE_H
#define __INTERRUPT_DESCRIPTOR_TABLE_H

/* --------------- Includes ---------------- */

#include "standard.h"
#include "strings.h"

/* ---------------- Defines ---------------- */

#define TRAP_GATE_FLAGS (0x8F)
#define INT_GATE_FLAGS  (0x8E)
#define SIZEOF_IDT      (256)

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

/* ---------- Function prototypes ---------- */

/* Initializes the interrupt descriptor table */
void InitIdt(void);

/* Add an ISR to the IDT */
void IdtSetDescriptor(Ubyte entryNumber, void(isr)(void), Ubyte flags);

/* Default handler that is triggered when an interrupt occurs */
void IntHandler(IntFrame *frame) INTERRUPT;

/* Default handler that is triggered when an exception without an error code occurs */
void ExcpHandler(IntFrame *frame) INTERRUPT;

/* Default handler that is triggered when an exception with an error code occurs  */
void ExcpHandlerError(IntFrame *frame, Uint errorCode) INTERRUPT;

#endif /* __INTERRUPT_DESCRIPTOR_TABLE_H */
