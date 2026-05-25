#ifndef KERNEL_H
#define KERNEL_H

/* --------------- Includes ---------------- */

#include "gdt.h"
#include "idt.h"
#include "keyboard.h"
#include "pic.h"
#include "pit.h"
#include "strings.h"

#ifdef GRUB
#include "memory.h"
#include "multiboot.h"
#endif

/* ---------------- Defines ---------------- */

#define KERNEL_PANIC() KernelPanic("Kernel panic at %s:%d!", __FILE__, __LINE__)

/* ----------------- Types ----------------- */

/* None */

/* ---------- Function prototypes ---------- */

void KernelPanic(const Char *format, ...);

#endif /* KERNEL_H */
