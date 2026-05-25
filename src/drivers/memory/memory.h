#ifndef MEMORY_H
#define MEMORY_H

/* --------------- Includes ---------------- */

#include "kernel.h"
#include "memops.h"
#include "multiboot.h"
#include "strings.h"
/* ---------------- Defines ---------------- */
/* @TODO: rename me */
#define BLOCKS_PER_BYTE (8)
#define BLOCK_SIZE      (4096)
#define BLOCK_ALIGNMENT (BLOCK_SIZE)

/* ----------------- Types ----------------- */

typedef struct {
    UintPtr addrLow;
    UintPtr addrHigh;
    Uint    lenLow;
    Uint    lenHigh;
} MemRegion;

/* ---------- Function prototypes ---------- */

void  InitMemory(MultiBootInfo *mbi);
Int   MMapGetFree(void);
void *MemAlloc(void);
Int   MemFree(void *ptr);

#endif /* MEMORY_H */
