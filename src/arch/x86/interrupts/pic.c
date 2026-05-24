/* --------------- Includes ---------------- */

#include "pic.h"

/* ---------- Function Prototypes ---------- */

/* None */

/* ----------- Global Variables ------------ */

static HandlerFn irqHandlers[SIZEOF_IDT - IRQ_BASE_OFFSET] = { 0 };

static const Char *exceptionName[IRQ_BASE_OFFSET] = {
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

static void SendEOI(Ubyte vector);

/* -------- Function Implementations ------- */

void InitPic(void) {
    PicRemap(0x20, 0x28);
}

void PicRemap(int offset1, int offset2) {
    Ubyte a1, a2;

    /* @TODO what is this __builtin? */
    // a1 = __builtin_ia32_inb(PIC1_DATA); // Save masks

    a1 = InByte(PIC1_DATA); // Save masks
    a2 = InByte(PIC2_DATA);

    OutByte(PIC1_COMMAND, 0x11); // Start initialization sequence (ICW1)
    IoWait();
    OutByte(PIC2_COMMAND, 0x11);
    IoWait();

    OutByte(PIC1_DATA, offset1); // ICW2: Master PIC vector offset
    IoWait();
    OutByte(PIC2_DATA, offset2); // ICW2: Slave PIC vector offset
    IoWait();

    OutByte(PIC1_DATA, 4); // ICW3: tell Master PIC there is a slave PIC at IRQ2
    IoWait();
    OutByte(PIC2_DATA, 2); // ICW3: tell Slave PIC its cascade identity
    IoWait();

    OutByte(PIC1_DATA, 0x01); // ICW4: 8086/88 (MCS-80/85) mode
    IoWait();
    OutByte(PIC2_DATA, 0x01);
    IoWait();

    OutByte(PIC1_DATA, a1); // Restore saved masks
    OutByte(PIC2_DATA, a2);
}

void InterruptDispatcher(CpuState *cpuState) {

    if (cpuState->vector < IRQ_BASE_OFFSET) {
        PrintString("Fatal Exception: ");
        PrintString(exceptionName[cpuState->vector]);
        PrintString("\n");

        /* @TODO: Implement in the future a KernelPanic function */
        while (TRUE) {
            ;
        }
    }

    PrintString("\n");

    if (irqHandlers[cpuState->vector - IRQ_BASE_OFFSET] != NULL) {
        irqHandlers[cpuState->vector - IRQ_BASE_OFFSET](cpuState);
    }

    /* @TODO: Create a define for 47 and explain why that's a limit */
    if (cpuState->vector >= IRQ_BASE_OFFSET && cpuState->vector <= 47) {
        SendEOI(cpuState->vector);
    }
}

void RegisterInterruptHandler(InterruptSourceE entry, HandlerFn handler) {
    irqHandlers[entry] = handler;
}

INLINE static void SendEOI(Ubyte vector) {
    /* @TODO: Turn 40 into a define */
    if (vector >= 40) {
        /* @TODO: Create defines/macro for these values */
        OutByte(0xA0, 0x20); // Slave PIC
    }
    OutByte(0x20, 0x20); // Master PIC
}
