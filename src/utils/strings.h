#ifndef STRINGS_H
#define STRINGS_H

/* --------------- Includes ---------------- */

#include "memops.h"
#include "standard.h"

/* ---------------- Defines ---------------- */

#define CHARS_PER_LINE (80)

/* ----------------- Types ----------------- */

/* None */

/* ---------- Function prototypes ---------- */

void  PrintString(const Char *format, ...);
Int   StrToInt(const Char *str);
Uint  StrLen(const Char *str);
void  StrReverse(Char *str);
Char *IntToStr(Long num, Char *str, Uint base);
void  VarArgPrint(const Char *format, VA_LIST args);
void  PrintChar(Char letter);

#endif /* STRINGS_H */
