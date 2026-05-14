/* --------------- Includes ---------------- */

#include "io.h"

/* ---------- Function Prototypes ---------- */

/* None */

/* ----------- Global Variables ------------ */

/* None */

/* -------- Function Implementations ------- */

void OutByte(Ushort port, Ubyte data) {
    ASM("outb %0, %1" : : "a"(data), "Nd"(port));
    return;
}

Ubyte InByte(Ushort port) {
    Ubyte res;
    ASM("inb %1, %0" : "=a"(res) : "Nd"(port));
    return res;
}

void OutWord(Ushort port, Ushort data) {
    ASM("outw %w0, %1" : : "a"(data), "id"(port));
}

Ushort InWord(Ushort port) {
    Ushort ret;
    ASM("inw %1, %0" : "=a"(ret) : "dN"(port));
    return ret;
}

void Wait(void) {
    ASM("outb %%al, $0x80" : : "a"(0));
}
