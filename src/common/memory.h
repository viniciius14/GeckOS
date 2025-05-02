#ifndef __MEMORY_H
#define __MEMORY_H

#include "utils.h"

/* ---------------- Defines ---------------- */

/* ----------------- Types ----------------- */

/* ---------- Function prototypes ---------- */

/* Sets n bytes of memory to value starting at address dst */
void MemSet(void *const dst, const uint8_t value, uint32_t n);

/* Copies n bytes of memory from src to dst */
void *MemCpy(void *const dst, const void *src, uint32_t n);

/* Moves n bytes from src to dst */
void *MemMove(void *const dst, void *const src, const uint32_t n);

/* Convert memory location from lba to chs addressing */
void ConvertLbaChs(const uint32_t lba, uint8_t *cyl, uint8_t *head, uint8_t *sector);

#endif /* __MEMORY_H */
