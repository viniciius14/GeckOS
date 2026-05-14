#ifndef IO_H
#define IO_H

/* --------------- Includes ---------------- */

#include "standard.h"

/* ---------------- Defines ---------------- */

/* None */

/* ----------------- Types ----------------- */

/* None */

/* ---------- Function prototypes ---------- */

void  OutByte(Ushort port, Ubyte data);
Ubyte InByte(Ushort port);
void  OutWord(Ushort port, Ushort data);
void  Wait(void);

#endif /* IO_H */
