#ifndef __STRINGS_H
#define __STRINGS_H

/* --------------- Includes ---------------- */

#include "standard.h"

/* ---------------- Defines ---------------- */

#define CHARS_PER_LINE      (80)

/* ----------------- Types ----------------- */

/* None */

/* ---------- Function prototypes ---------- */

void PrintString(const char *str);
void PrintInt(int num);
void PrintDouble(double num);
void PrintHex(Ulong num);

Uint StrLen(const char *str);

#endif /* __STRINGS_H */
