/* --------------- Includes ---------------- */

#include "interruptDescriptorTable.h"

/* ---------- Function Prototypes ---------- */

void SendEOI(Ubyte vector);

/* ----------- Global Variables ------------ */

ALIGNED(16) IdtEntry interruptDescriptorTable[SIZEOF_IDT];

static const IdtPtr idtPtr = {
    .limit = (Ushort)(sizeof(interruptDescriptorTable) - 1),
    .base  = (Uint)&interruptDescriptorTable[0],
};

/* -------- Function Implementations ------- */

INTERRUPT void DftExcpHandler(IntFrame *frame) {
    (void)frame;
    PrintString("DftExcpHandler was called\n");
    // SendEOI();
}

void DftExcpHandlerError(IntFrame *frame, Uint errorCode) {
    (void)frame;
    PrintString("DftExcpHandlerError was called with error code: ");
    PrintInt(errorCode);
    PrintString(" \n");
    // SendEOI();
}

void DftIntHandler(InterruptStack *intStack) {
    PrintString("DftIntHandler was called!\n");

    if (intStack->intNb == INT_START_OFFSET) {
        // Timer logic
    }

    // Don't forget the EOI for hardware interrupts!
    if (intStack->intNb >= INT_START_OFFSET) {
        SendEOI(intStack->intNb);
    }

    //  SendEOI(intStack->intNb);
}

void IdtSetDescriptor(Ubyte entryNumber, IsrFnPtr isr, Ubyte flags) {
    IdtEntry *descriptor = &interruptDescriptorTable[entryNumber];

    descriptor->isrLow     = ((Uint)isr >> 0) & 0xFFFF;
    descriptor->kernelCS   = 0x08;
    descriptor->reserved   = 0;
    descriptor->attributes = flags;
    descriptor->isrHigh    = ((Uint)isr >> 16) & 0xFFFF;
}

void InitIdt(void) {
    /* Setup exception handler ISR 0 - 31 */
    for (Ushort entry = 0; entry < INT_START_OFFSET; entry++) {
        if (entry == 8 || (entry >= 10 && entry <= 14) || entry == 17 || entry == 21) {
            /* Exceptions with error codes */
            IdtSetDescriptor(entry, (IsrFnPtr)DftExcpHandlerError, TRAP_GATE_FLAGS);
        } else {
            /* Exceptions without error codes */
            IdtSetDescriptor(entry, (IsrFnPtr)DftExcpHandler, INT_GATE_FLAGS);
        }
    }

    /* Setup all other interrupts ISRs 32 - 255 */
    for (Ushort entry = INT_START_OFFSET; entry < SIZEOF_IDT; entry++) {
        IdtSetDescriptor(entry, (IsrFnPtr)DftIntHandler, INT_GATE_FLAGS);
    }

    ASM("lidt %0" : : "memory"(idtPtr));
}

INLINE void SendEOI(Ubyte vector) {
    if (vector >= 40) {
        OutByte(0xA0, 0x20); // Slave PIC
    }
    OutByte(0x20, 0x20); // Master PIC
}