#ifndef __STANDARD_H
#define __STANDARD_H

/* --------------- Includes ---------------- */

#include "Strings.h"
#include "Types.h"

/* ---------------- Defines ---------------- */

#define VA_ARGS_NEXT(_sp, _type) (vaArgs_next(_sp, sizeof(_type)))

/* ----------------- Types ----------------- */

/* None */

/* ---------- Function prototypes ---------- */

int32_t strToInt(const char *str);
void    vaArgs_start(vaArg_t *arg, const char *str);
void    vaArgs_next(vaArg_t *arg, );
void    vaArgs_end(vaArg_t *arg);

#endif /* __STANDARD_H */
