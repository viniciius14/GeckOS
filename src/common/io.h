#ifndef __IO_H
#define __IO_H

#include "utils.h"

/* ---------------- Defines ---------------- */

/* ----------------- Types ----------------- */

/* ---------- Function prototypes ---------- */

/* Outputs a byte to the specified hardware port */
void outbyte(uint16_t, uint8_t);

/* Outputs a word to the specified hardware port */
void outword(uint16_t, uint16_t);

/* Gets a byte from the specified hardware port */
uint8_t inbyte(uint16_t);

/* Gets a word from to the specified hardware port */
uint16_t inword(uint16_t);

void outlong(uint16_t port, uint32_t value);

uint32_t inlong(uint16_t port);

/* Wait 1 I/O cycle for I/O operation to complete */
void io_wait(void);

#endif /* __IO_H */
