#ifndef MEMOPS_H
#define MEMOPS_H

/* --------------- Includes ---------------- */

#include "standard.h"

/* ---------------- Defines ---------------- */

/* None */

/* ----------------- Types ----------------- */

/* None */

/* ---------- Function prototypes ---------- */

void *MemSet(void *dest, Int val, Int len);
void *MemCpy(void *dest, const void *src, Int len);
Int   MemCmp(const void *s1, const void *s2, Int len);

#endif /* MEMOPS_H */
