#include "memory.h"

void lba_2_chs(uint32_t lba, uint8_t *cyl, uint8_t *head, uint8_t *sector) {
    *cyl    = lba / (2 * 18);
    *head   = ((lba % (2 * 18)) / 18);
    *sector = ((lba % (2 * 18)) % 18 + 1);
}