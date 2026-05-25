/* --------------- Includes ---------------- */

#include "memory.h"

/* ---------- Function Prototypes ---------- */

static void MMapSet(Int bit);
static void MMapUnset(Int bit);
static Bool MMapTest(Int bit);
static Int  GetFreeBlockCount(void);

/* ----------- Global Variables ------------ */

static Uint  memorySize     = 0;
static Uint  maxBlocks      = 0;
static Uint  memoryBaseAddr = 0;
static Uint *memoryMap      = NULL;
static Uint  usedBlocks     = 0;

/* -------- Function Implementations ------- */

void InitMemory(MultiBootInfo *mbi) {
    for (Uint i = 0; i < mbi->mmapLength; i += sizeof(MmapEntry)) {
        MmapEntry *entry = (MmapEntry *)(mbi->mmapAddr + i);

        PrintString(
            "Low addr: %x | Low Length: %x | Size: %x | Type: %d\n", entry->addrLow, entry->lenLow,
            entry->size, entry->type
        );

        if (entry->type == E_MEMORY_AVAILABLE && entry->addrLow >= MB(1)) {
            memorySize = entry->lenLow;

            // 1. Place the bitmap at the start of this available region (1MB+)
            memoryMap = (Uint *)(ROUND_UP(entry->addrLow, 16));

            // 2. Figure out how many blocks total fit in the region
            Uint totalPossibleBlocks = entry->lenLow / BLOCK_SIZE;

            // 3. Estimate bytes needed for the tracking map
            Uint bitmapSizeInBytes = (totalPossibleBlocks + 7) / 8;

            // 4. Set the actual memory base *after* the bitmap, aligned to a block boundary
            memoryBaseAddr = ROUND_UP((Uint)memoryMap + bitmapSizeInBytes, BLOCK_SIZE);

            // 5. Calculate remaining available blocks for the allocator
            Uint overheadBytes = memoryBaseAddr - entry->addrLow;
            if (entry->lenLow > overheadBytes) {
                maxBlocks = (entry->lenLow - overheadBytes) / BLOCK_SIZE;
            } else {
                maxBlocks = 0;
            }

            break;
        }
    }

    if (maxBlocks > 0) {
        Uint actualBitmapBytes = (maxBlocks + 31) / 32 * sizeof(Uint);
        MemSet(memoryMap, 0, actualBitmapBytes);
    }

    return;
}

Int MMapGetFree(void) {
    for (Uint i = 0; i < maxBlocks / 32; i++) {
        if (memoryMap[i] != MAX_UINT32) {
            for (Int j = 0; j < 32; j++) {
                Uint bit = 1 << j;
                if (!(memoryMap[i] & bit)) {
                    Uint blockIndex = i * 32 + j;
                    if (blockIndex < maxBlocks) {
                        return (Int)blockIndex;
                    }
                }
            }
        }
    }
    return -1;
}

void *MemAlloc(void) {
    if (GetFreeBlockCount() <= 0) {
        return NULL;
    }

    Int frame = MMapGetFree();
    if (frame == -1) {
        return NULL;
    }

    MMapSet(frame);

    Uint addr = memoryBaseAddr + (frame * BLOCK_SIZE);
    usedBlocks++;

    PrintString("Allocated a 4K block starting at addr: %p\n", (void *)addr);
    return (void *)addr;
}

Int MemFree(void *ptr) {
    if (ptr == NULL) {
        return -1;
    }

    Uint addr = (Uint)ptr;

    // FIX: Ensure pointer resides within our managed allocation bounds
    if (addr < memoryBaseAddr) {
        return -1;
    }

    Uint frame = (addr - memoryBaseAddr) / BLOCK_SIZE;

    if (frame >= maxBlocks) {
        return -1;
    }

    if (!MMapTest(frame)) {
        return -1;
    }

    MMapUnset(frame);

    if (usedBlocks > 0) {
        usedBlocks--;
    }

    PrintString("Freed a 4K block with addr: %p\n", (void *)addr);
    return 0;
}

INLINE static void MMapSet(Int bit) {
    memoryMap[bit / 32] |= (1 << (bit % 32));
}

INLINE static void MMapUnset(Int bit) {
    memoryMap[bit / 32] &= ~(1 << (bit % 32));
}

INLINE static Bool MMapTest(Int bit) {
    return memoryMap[bit / 32] & (1 << (bit % 32));
}

INLINE static Int GetFreeBlockCount(void) {
    return maxBlocks - usedBlocks;
}
