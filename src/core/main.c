/* --------------- Includes ---------------- */

#include "globalDescriptorTable.h"
#include "interruptDescriptorTable.h"
#include "pic.h"
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
    PicRemap();

    STI();

    for (;;) {
    }
}
