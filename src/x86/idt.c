/* --------------- Includes ---------------- */

#include "idt.h"

/* ---------- Function Prototypes ---------- */

/* None */

/* ----------- Global Variables ------------ */

extern Uint isrStubTable[SIZEOF_IDT];

ALIGNED(16) static IdtEntry interruptDescriptorTable[SIZEOF_IDT] = { 0 };

static const IdtPtr idtPtr = {
    .limit = (Ushort)(sizeof(interruptDescriptorTable) - 1),
    .base  = (Uint)&interruptDescriptorTable[0],
};

/* -------- Function Implementations ------- */

void InitIdt(void) {
    /* Setup exception handler ISR 0 - 31 */
    for (Ushort entry = 0; entry < IRQ_BASE_OFFSET; entry++) {
        if (entry == 8 || (entry >= 10 && entry <= 14) || entry == 17 || entry == 21) {
            /* Trap with error codes */
            IdtSetDescriptor(entry, (Isr)isrStubTable[entry], TRAP_GATE_FLAGS);
        } else {
            /* Interrupt without error codes */
            IdtSetDescriptor(entry, (Isr)isrStubTable[entry], INT_GATE_FLAGS);
        }
    }

    /* Setup all other interrupts ISRs 32 - 255 */
    for (Ushort entry = IRQ_BASE_OFFSET; entry < SIZEOF_IDT; entry++) {
        IdtSetDescriptor(entry, (Isr)isrStubTable[entry], INT_GATE_FLAGS);
    }

    ASM("lidt %0" : : "memory"(idtPtr));
}

void IdtSetDescriptor(Ubyte entryNumber, Isr isr, Ubyte flags) {
    IdtEntry *descriptor = &interruptDescriptorTable[entryNumber];

    descriptor->isrLow     = ((Uint)isr >> 0) & 0xFFFF;
    descriptor->kernelCS   = GDT_KERNEL_CODE_SEG;
    descriptor->reserved   = 0;
    descriptor->attributes = flags;
    descriptor->isrHigh    = ((Uint)isr >> 16) & 0xFFFF;
}
