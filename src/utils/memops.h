#ifndef MEMOPS_H
#define MEMOPS_H

/* --------------- Includes ---------------- */

#include "standard.h"

/* ---------------- Defines ---------------- */

/* None */

/* ----------------- Types ----------------- */

/* None */

/* ---------- Function prototypes ---------- */

void *Memset(void *dest, Int val, Int len);
void *Memcpy(void *dest, const void *src, Int len);
Int   Memcmp(const void *s1, const void *s2, Int len);

#endif /* MEMOPS_H */
