#ifndef IDT_H
#define IDT_H

/* --------------- Includes ---------------- */

#include "gdt.h"
#include "io.h"
#include "pic.h"
#include "standard.h"

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

typedef void (*Isr)(void *);

/* ---------- Function prototypes ---------- */

/* Initializes the interrupt descriptor table */
void InitIdt(void);

/* Add an ISR to the IDT */
void IdtSetDescriptor(Ubyte entryNumber, Isr isr, Ubyte flags);

#endif /* INTERRUPT_DESCRIPTOR_TABLE_H */
