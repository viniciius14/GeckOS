/* --------------- Includes ---------------- */

#include "globalDescriptorTable.h"
#include "interruptDescriptorTable.h"
#include "strings.h"

/* ---------- Function Prototypes ---------- */

/* None */

/* ----------- Global Variables ------------ */

/* None */

/* -------- Function Implementations ------- */

void KernelMain(void) {
    CLI();
    PrintString("Hello from GeckOS!\n");

    InitIdt();
    InitGdt();

    STI();
}
