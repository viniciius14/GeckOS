#ifndef KERNEL_H
#define KERNEL_H

/* --------------- Includes ---------------- */

#include "gdt.h"
#include "idt.h"
#include "keyboard.h"
#include "pic.h"
#include "pit.h"
#include "strings.h"

/* ---------------- Defines ---------------- */

/* None */

/* ----------------- Types ----------------- */

/* None */

/* ---------- Function prototypes ---------- */

void KernelPanic(const Char *format, ...);

#endif /* KERNEL_H */
