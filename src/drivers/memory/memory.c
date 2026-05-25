/* --------------- Includes ---------------- */

#include "memory.h"

/* ---------- Function Prototypes ---------- */

/* None */

/* ----------- Global Variables ------------ */

/* None */

/* -------- Function Implementations ------- */

void InitMemory(MultiBootInfo *mbi) {
    for (Uint i = 0; i < mbi->mmapLength; i += sizeof(MmapEntry)) {
        MmapEntry *entry = (MmapEntry *)(mbi->mmapAddr + i);

        PrintString(
            "Low addr: %x | Low Length: %x | Size: %x | Type: %d\n", entry->addrLow, entry->lenLow,
            entry->size, entry->type
        );
    }
}
