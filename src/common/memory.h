#ifndef __MEMORY_H
#define __MEMORY_H

#include "utils.h"

/* ---------------- Defines ---------------- */

/* ----------------- Types ----------------- */

/* ---------- Function prototypes ---------- */

/* Sets n bytes of memory to value starting at address dst */
#ifdef BITS_64
void memset(void *, uint8_t, uint64_t);
#else
void memset(void *, uint8_t, uint32_t);
#endif

/* Copies n bytes of memory from src to dst */
#ifdef BITS_64
void *memcpy(void *, const void *, uint64_t);
#else
void *memcpy(void *, const void *, uint32_t);
#endif

/* Moves n bytes from src to dst */
#ifdef BITS_64
void *memmove(void *, const void *, uint64_t);
#else
void *memmove(void *, const void *, uint32_t);
#endif

#endif /* __MEMORY_H */
