#ifndef __MEMORY_H
#define __MEMORY_H

#include "utils.h"

/* ---------------- Defines ---------------- */

/* ----------------- Types ----------------- */

/* ---------- Function prototypes ---------- */

/* Sets n bytes of memory to value starting at address dst */
void memset(void *dst, uint8_t value, uint32_t n);

/* Copies n bytes of memory from src to dst */
void *memcpy(void *dst, const void *src, uint32_t n);

/* Moves n bytes from src to dst */
void *memmove(void *dst, const void *src, uint32_t n);

#endif /* __MEMORY_H */
