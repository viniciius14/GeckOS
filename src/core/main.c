/* --------------- Includes ---------------- */

#include "gdt.h"
#include "idt.h"
#include "pic.h"
#include "pit.h"

#include "strings.h"

/* ---------- Function Prototypes ---------- */

/* None */

/* ----------- Global Variables ------------ */

/* None */

/* -------- Function Implementations ------- */

void KernelMain(void) {
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
