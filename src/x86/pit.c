/* --------------- Includes ---------------- */

#include "pit.h"

/* ---------- Function Prototypes ---------- */

static void PitIntHandler(CpuState *cpuState);

/* ----------- Global Variables ------------ */

Ulong ticks = 0;

/* -------- Function Implementations ------- */

void InitPit(Uint frequency) {
    Uint divisor = PIT_BASE_FREQUENCY / frequency;

    // Command byte: Channel 0, access mode low/high byte, square wave mode, 16-bit binary
    // 0x36 = 00110110b
    OutByte(PIT_COMMAND, 0x36);

    // Set the frequency divisor (split into low/high bytes)
    OutByte(PIT_DATA0, (Ubyte)((divisor >> 0) & 0xFF));
    OutByte(PIT_DATA0, (Ubyte)((divisor >> 8) & 0xFF));

    RegisterInterruptHandler(E_PIC_INT, PitIntHandler);
}

static void PitIntHandler(CpuState *cpuState) {
    ticks++;
    SendEOI(cpuState->vector);
}
