#include "memory.h"

void memset(const void *dst, const uint8_t value, uint32_t n) {
    uint8_t *d = dst;
    while (n-- > 0) {
        *(d++) = value;
    }
}


void *memcpy(const void *dst, const void *src, uint32_t n) {
    uint8_t *d = dst;
    const uint8_t *s = src;

    while (n-- > 0) {
        *(d++) = *(s++);
    }
    return dst;
}


void *memmove(const void *dst, const void *src, const uint32_t n) {
    if (src > dst) {
        return memcpy(dst, src, n);
    }

    uint8_t *d = dst;
    const uint8_t *s = src;

    for (uint32_t i = n ; i > 0 ; i--) {
        d[i - 1] = s[i - 1];
    }

    return dst;
}


INLINE void lba_2_chs(const uint32_t lba, uint8_t *cyl, uint8_t *head, uint8_t *sector) {
    *cyl    = lba / (2 * 18);
    *head   = ((lba % (2 * 18)) / 18);
    *sector = ((lba % (2 * 18)) % 18 + 1);
}
