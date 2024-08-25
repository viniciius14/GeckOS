#ifndef __MEMORY_H
#define __MEMORY_H

#include "utils.h"

/* ---------------- Defines ---------------- */


/* ----------------- Types ----------------- */


/* ---------- Function prototypes ---------- */

void lba_2_chs(uint32_t lba, uint8_t *cyl, uint8_t *head, uint8_t *sector);

#endif /* __MEMORY_H */
