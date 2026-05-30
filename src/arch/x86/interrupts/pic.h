#ifndef PIC_H
#define PIC_H

/* --------------- Includes ---------------- */

#include "idt.h"
#include "io.h"
#include "strings.h"

/* ---------------- Defines ---------------- */

#define PIC1_COMMAND (0x20)
#define PIC1_DATA    (0x21)
#define PIC2_COMMAND (0xA0)
#define PIC2_DATA    (0xA1)

#define PIC_EOI      (0x20)

/* ----------------- Types ----------------- */

/* Interrupt frame to pass to interrupt handlers */
/* @TODO: Rename me / not is use atm */
typedef struct {
    Uint eip;
    Uint cs;
    Uint eFlags;
    // The following are only valid if a privilege switch occurred:
    Uint userEsp;
    Uint UserSs;
} PACKED InterruptState;

typedef struct {
    Uint ds;
    Uint edi, esi, ebp, esp, ebx, edx, ecx, eax; // GPRs
    Uint vector, errorCode;
    // Pushed by the CPU hardware
    InterruptState intState;
} PACKED CpuState;

typedef void (*HandlerFn)(CpuState *);

typedef enum {
    E_PIT_INT,
    E_KEYBOARD_INT,
    E_CASCADE_SLAVE_PIC_INT,
    E_COM2,
    E_COM1_INT,
    E_LPT2_INT,
    E_FLOPPY_INT,
    E_LPT1_INT,
    E_RTC_INT,
    E_ACPI_INT,
    E_PCI_INT,
    E_PS2_MOUSE_INT,
    E_FPU_INT,
    E_PRIMARY_ATA_INT,
    E_SECONDARY_ATA_INT
} InterruptSourceE;

/* ---------- Function prototypes ---------- */

void InitPic(void);

void PicRemap(int offset1, int offset2);

/* Default handler that is triggered when an interrupt occurs */
void InterruptDispatcher(CpuState *cpuState);

void RegisterInterruptHandler(InterruptSourceE entry, HandlerFn handler);

#endif /* PIC_H */
