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
    InitKeyboard();

    STI();

    for (;;) {
    }
}

NORETURN void KernelPanic(const Char *format, ...) {
    PrintString("\n!!! KERNEL PANIC !!!\n");

    VA_LIST args;
    VA_START(args, format);

    VarArgPrint(format, args);

    VA_END(args);

    while (TRUE) {
        ASM("hlt");
    }
}
