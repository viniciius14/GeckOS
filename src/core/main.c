/* --------------- Includes ---------------- */

#include "strings.h"
#include "interruptDescriptorTable.h"

/* ---------- Function Prototypes ---------- */

/* None */

/* ----------- Global Variables ------------ */

/* None */

/* -------- Function Implementations ------- */

// cppcheck-suppress unusedFunction
void KernelMain(void) {
    PrintString("Hello from GeckOS!\n");
    InitIdt();
}
