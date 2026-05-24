/* --------------- Includes ---------------- */

#include "kernel.h"

/* ---------- Function Prototypes ---------- */

void KernelMain(void);

/* ----------- Global Variables ------------ */

/* None */

/* -------- Function Implementations ------- */

NORETURN void KernelMain(void) {
    CLI();
    PrintString("Hello from GeckOS!\n");

    InitGdt();
    InitIdt();
    InitPic();
    InitPit(10);

    STI();

    for (;;) {
    }
}

NORETURN void KernelPanic(const Char *format, ...) {
    PrintString("\n!!! KERNEL PANIC !!!\n");

    __builtin_va_list args;
    __builtin_va_start(args, format);

    VarArgPrint(format, args);

    __builtin_va_end(args);

    while (1) {
        ASM("hlt");
    }
}
