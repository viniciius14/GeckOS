/* --------------- Includes ---------------- */

#include "memops.h"

/* ---------- Function Prototypes ---------- */

/* None */

/* ----------- Global Variables ------------ */

/* None */

/* -------- Function Implementations ------- */

void *Memset(void *dest, Int val, Int len) {
    Ubyte *ptr = (Ubyte *)dest;
    while (len-- > 0) {
        *ptr++ = (Ubyte)val;
    }
    return dest;
}

void *Memcpy(void *dest, const void *src, Int len) {
    Char       *d = (Char *)dest;
    const Char *s = (const Char *)src;
    while (len-- > 0) {
        *d++ = *s++;
    }
    return dest;
}

Int Memcmp(const void *s1, const void *s2, Int len) {
    const Ubyte *p1 = (const Ubyte *)s1;
    const Ubyte *p2 = (const Ubyte *)s2;
    while (len-- > 0) {
        if (*p1 != *p2) {
            return *p1 - *p2;
        }
        p1++;
        p2++;
    }
    return 0;
}
