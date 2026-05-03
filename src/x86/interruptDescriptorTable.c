/* --------------- Includes ---------------- */

#include "interruptDescriptorTable.h"

/* ---------- Function Prototypes ---------- */

/* None */

/* ----------- Global Variables ------------ */

IdtEntry idt32[SIZEOF_IDT];
IdtPtr   idtPtr;

/* -------- Function Implementations ------- */

INTERRUPT void ExcpHandler(IntFrame *frame) {
    (void)frame;
    PrintString("ExcpHandler was called\n");
}

INTERRUPT void ExcpHandlerError(IntFrame *frame, Uint errorCode) {
    (void)frame;
    PrintString("ExcpHandlerError was called with error code: ");
    PrintInt(errorCode);
    PrintString(" \n");
}

INTERRUPT void IntHandler(IntFrame *frame) {
    (void)frame;
    PrintString("IntHandler was called!\n");
}

void IdtSetDescriptor(Ubyte entryNumber, IsrFnPtr isr, Ubyte flags) {
    IdtEntry *descriptor = &idt32[entryNumber];

    descriptor->isrLow     = ((Uint)isr >> 0) & 0xFFFF;
    descriptor->kernelCS   = 0x08;
    descriptor->reserved   = 0;
    descriptor->attributes = flags;
    descriptor->isrHigh    = ((Uint)isr >> 16) & 0xFFFF;
}

void InitIdt(void) {
    idtPtr.limit = (Ushort)((sizeof(IdtEntry) * SIZEOF_IDT) - 1);
    idtPtr.base  = (Uint)&idt32[0];

    /* Setup exception handler ISR 0 - 31 */
    for (Ushort entry = 0; entry < 32; entry++) {
        if (entry == 8 || (entry >= 10 && entry <= 14) || entry == 17 || entry == 21) {
            /* Exceptions with error codes */
            IdtSetDescriptor(entry, (IsrFnPtr)ExcpHandlerError, TRAP_GATE_FLAGS);
        } else {
            /* Exceptions without error codes */
            IdtSetDescriptor(entry, (IsrFnPtr)ExcpHandler, INT_GATE_FLAGS);
        }
    }

    /* Setup all other interrupts ISRs 32 - 255 */
    for (Ushort entry = 32; entry < SIZEOF_IDT; entry++) {
        IdtSetDescriptor(entry, (IsrFnPtr)IntHandler, INT_GATE_FLAGS);
    }

    ASM("lidt %0" : : "memory"(idtPtr));
}
