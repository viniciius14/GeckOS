/* --------------- Includes ---------------- */

#include "idt.h"

/* ---------- Function Prototypes ---------- */

/* None */

/* ----------- Global Variables ------------ */

extern Uint isrStubTable[SIZEOF_IDT];

ALIGNED(16) static IdtEntry interruptDescriptorTable[SIZEOF_IDT] = { 0 };

ALIGNED(16) static HandlerFn irqHandlers[SIZEOF_IDT] = { 0 };

static const IdtPtr idtPtr = {
    .limit = (Ushort)(sizeof(interruptDescriptorTable) - 1),
    .base  = (Uint)&interruptDescriptorTable[0],
};

static const char *exceptionName[IRQ_BASE_OFFSET] = {
    "Divide by zero",
    "Debug",
    "NMI",
    "Breakpoint",
    "Overflow",
    "OOB",
    "Invalid opcode",
    "No coprocessor",
    "Double fault",
    "Coprocessor segment overrun",
    "Bad TSS",
    "Segment not present",
    "Stack fault",
    "General protection fault",
    "Page fault",
    "Unrecognized interrupt",
    "Coprocessor fault",
    "Alignment check",
    "Machine check",
    "RESERVED",
    "RESERVED",
    "RESERVED",
    "RESERVED",
    "RESERVED",
    "RESERVED",
    "RESERVED",
    "RESERVED",
    "RESERVED",
    "RESERVED",
    "RESERVED",
};

/* -------- Function Implementations ------- */

void InterruptDispatcher(CpuState *cpuState) {
    PrintString("InterruptDispatcher was called! Int Number :");
    PrintInt(cpuState->vector);

    if (cpuState->vector < IRQ_BASE_OFFSET) {
        PrintString("Fatal Exception: ");
        PrintString(exceptionName[cpuState->vector]);
        PrintString(" Number: ");
        PrintInt(cpuState->vector);
        PrintString("\n");
        /* @TODO: Implement in the future a kernelPanic function */
        while (TRUE) {
            ;
        }
    }

    PrintString("\n");

    if (irqHandlers[cpuState->vector] != NULL) {
        irqHandlers[cpuState->vector](cpuState);
    }

    /* @TODO: Create a define for 47 and explain why that's a limit */
    if (cpuState->vector >= IRQ_BASE_OFFSET && cpuState->vector <= 47) {
        SendEOI(cpuState->vector);
    }
}

void IdtSetDescriptor(Ubyte entryNumber, HandlerFn isr, Ubyte flags) {
    IdtEntry *descriptor = &interruptDescriptorTable[entryNumber];

    descriptor->isrLow     = ((Uint)isr >> 0) & 0xFFFF;
    descriptor->kernelCS   = GDT_KERNEL_CODE_SEG;
    descriptor->reserved   = 0;
    descriptor->attributes = flags;
    descriptor->isrHigh    = ((Uint)isr >> 16) & 0xFFFF;
}

void InitIdt(void) {
    /* Setup exception handler ISR 0 - 31 */
    for (Ushort entry = 0; entry < IRQ_BASE_OFFSET; entry++) {
        if (entry == 8 || (entry >= 10 && entry <= 14) || entry == 17 || entry == 21) {
            /* ExceptionName with error codes */
            IdtSetDescriptor(entry, (HandlerFn)isrStubTable[entry], TRAP_GATE_FLAGS);
        } else {
            /* ExceptionName without error codes */
            IdtSetDescriptor(entry, (HandlerFn)isrStubTable[entry], INT_GATE_FLAGS);
        }
    }

    /* Setup all other interrupts ISRs 32 - 255 */
    for (Ushort entry = IRQ_BASE_OFFSET; entry < SIZEOF_IDT; entry++) {
        IdtSetDescriptor(entry, (HandlerFn)isrStubTable[entry], INT_GATE_FLAGS);
    }

    ASM("lidt %0" : : "memory"(idtPtr));
}

void RegisterInterruptHandler(Ushort entry, HandlerFn handler) {
    irqHandlers[entry] = handler;
}

INLINE void SendEOI(Ubyte vector) {
    /* @TODO: Turn 40 into a define */
    if (vector >= 40) {
        OutByte(0xA0, 0x20); // Slave PIC
    }
    OutByte(0x20, 0x20); // Master PIC
}
