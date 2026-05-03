#ifndef STRINGS_H
#define STRINGS_H

/* --------------- Includes ---------------- */

#include "standard.h"

/* ---------------- Defines ---------------- */

#define CHARS_PER_LINE (80)

/* ----------------- Types ----------------- */

/* None */

/* ---------- Function prototypes ---------- */

void PrintString(const char *str);
void PrintInt(int num);
void PrintDouble(double num);
void PrintHex(Ulong num);

Uint StrLen(const char *str);

#endif /* STRINGS_H */
