#ifndef MULTIBOOT_H
#define MULTIBOOT_H

/* --------------- Includes ---------------- */

#include "standard.h"

/* ---------------- Defines ---------------- */

/* None */

/* ----------------- Types ----------------- */

/* The symbol table for a.out. */
typedef struct {
    Uint tabsize;
    Uint strsize;
    Uint addr;
    Uint reserved;
} AoutSymbolTable;

/* The section header table for ELF. */
typedef struct {
    Uint num;
    Uint size;
    Uint addr;
    Uint shndx;
} ElfSectionHeaderTable;

typedef struct {
    /* Multiboot info version number */
    Uint flags;

    /* Available memory from BIOS */
    Uint memLower;
    Uint memUpper;

    /* "root" partition */
    Uint bootDevice;

    /* Kernel command line */
    Uint cmdLine;

    /* Boot-Module list */
    Uint modsCount;
    Uint modsAddr;

    union {
        AoutSymbolTable       aoutSym;
        ElfSectionHeaderTable elfSec;
    } u;

    /* Memory Mapping buffer */
    Uint mmapLength;
    Uint mmapAddr;

    /* Drive Info buffer */
    Uint drivesLength;
    Uint drivesAddr;

    /* ROM configuration table */
    Uint configTable;

    /* Boot Loader Name */
    Uint bootLoaderName;

    /* APM table */
    Uint apmTable;

    /* Video */
    Uint   vbeControlInfo;
    Uint   vbeModeInfo;
    Ushort vbeMode;
    Ushort vbeInterfaceSeg;
    Ushort vbeInterfaceOff;
    Ushort vbeInterfaceLen;

    Ulong framebufferAddr;
    Uint  framebufferPitch;
    Uint  framebufferWidth;
    Uint  framebufferHeight;
    Ubyte framebufferBpp;
    Ubyte framebufferType;
    union {
        struct {
            Uint   framebufferPaletteAddr;
            Ushort framebufferPaletteNumColors;
        };
        struct {
            Ubyte framebufferRedFieldPosition;
            Ubyte framebufferRedMaskSize;
            Ubyte framebufferGreenFieldPosition;
            Ubyte framebufferGreenMaskSize;
            Ubyte framebufferBlueFieldPosition;
            Ubyte framebufferBlueMaskSize;
        };
    };
} MultiBootInfo;

typedef struct {
    Uint size;
    Uint addrLow;
    Uint addrHigh;
    Uint lenLow;
    Uint lenHigh;
    Uint type;
} PACKED MmapEntry;

typedef enum {
    FRAMEBUFFER_TYPE_INDEXED,
    FRAMEBUFFER_TYPE_RGB,
    FRAMEBUFFER_TYPE_EGA_TEXT,
} FrameBufferType;

typedef enum {
    E_MEMORY_AVAILABLE = 1,
    E_MEMORY_RESERVED,
    E_MEMORY_ACPI_RECLAIMABLE,
    E_MEMORY_NVS,
    E_MEMORY_BADRAM,
} MemoryType;

/* ---------- Function prototypes ---------- */

/* None */

#endif /* MULTIBOOT_H */
