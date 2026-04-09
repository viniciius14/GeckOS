#ifndef __STRINGS_H
#define __STRINGS_H

/* --------------- Includes ---------------- */

#include "Standard.h"
#include "Types.h"

/* ---------------- Defines ---------------- */

/* ----------------- Types ----------------- */

/* ---------- Function prototypes ---------- */
uint32_t strlen(const char *str);
void     print(const char *str);
void     printInteger(int num);
void     printDouble(double num);
void     printHex(uint64_t num);

#endif /* __STRINGS_H */
