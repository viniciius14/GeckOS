#ifndef __MEMORY_H
#define __MEMORY_H

#include "utils.h"

/* ---------------- Defines ---------------- */

/* ----------------- Types ----------------- */

/* ---------- Function prototypes ---------- */

/* Sets n bytes of memory to value starting at address dst */
void memset(const void *dst, const uint8_t value, uint32_t n);

/* Copies n bytes of memory from src to dst */
void *memcpy(const void *dst, const void *src, uint32_t n);

/* Moves n bytes from src to dst */
void *memmove(const void *dst, const void *src, const uint32_t n);

/* Convert memory location from lba to chs addressing */
void lba_2_chs(const uint32_t lba, uint8_t *cyl, uint8_t *head, uint8_t *sector);

#endif /* __MEMORY_H */
