#ifndef KEYBOARD_H
#define KEYBOARD_H

/* --------------- Includes ---------------- */

#include "io.h"
#include "pic.h"
#include "standard.h"

/* ---------------- Defines ---------------- */

#define PS2_DATA_PORT (0x60)

#define KEY_NULL      (0x00)
#define KEY_ENTER     ('\n')
#define KEY_BACKSPACE (0x08)
#define KEY_TAB       (0x09)

/* ----------------- Types ----------------- */

/* None */

/* ---------- Function prototypes ---------- */

/* Initializes the interrupt for the keyboard and clears it's buffer */
void InitKeyboard(void);

/* PIC IRQ1 interrupt handler */
void KeyboardHandler(const CpuState *cpuState);

#endif /* KEYBOARD_H */
