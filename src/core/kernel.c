/* --------------- Includes ---------------- */

#include "kernel.h"

/* ---------- Function Prototypes ---------- */
#ifdef GRUB
void KernelMain(Uint magic, MultiBootInfo *mbi);
#else
void KernelMain(void);
#endif

/* ----------- Global Variables ------------ */

/* None */

/* -------- Function Implementations ------- */

#ifdef GRUB
NORETURN void KernelMain(Uint magic, MultiBootInfo *mbi) {
#else
NORETURN void KernelMain(void) {
#endif
    CLI();
    PrintString("Hello from GeckOS!\n");

    InitGdt();
    InitIdt();
    InitPic();

#ifdef GRUB
    (void)magic;
    InitMemory(mbi);
#endif

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
