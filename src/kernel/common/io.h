#ifndef __IO_H
#define __IO_H

#include "utils.h"

/* ---------------- Defines ---------------- */

/* ----------------- Types ----------------- */

/* ---------- Function prototypes ---------- */

/* Outputs a byte to the specified hardware port */
void OutByte(uint16_t, uint8_t);

/* Outputs a word to the specified hardware port */
void OutWord(uint16_t, uint16_t);

/* Gets a byte from the specified hardware port */
uint8_t InByte(uint16_t);

/* Gets a word from to the specified hardware port */
uint16_t InWord(uint16_t);

/* Wait 1 I/O cycle */
void IoWait(void);

#endif /* __IO_H */
