/* --------------- Includes ---------------- */

#include "interruptDescriptorTable.h"
#include "globalDescriptorTable.h"
#include "strings.h"

/* ---------- Function Prototypes ---------- */

/* None */

/* ----------- Global Variables ------------ */

/* None */

/* -------- Function Implementations ------- */

// cppcheck-suppress unusedFunction
void KernelMain(void) {
    PrintString("Hello from GeckOS!\n");

    InitIdt();
    InitGdt();
}
