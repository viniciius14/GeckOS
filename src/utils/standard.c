/* --------------- Includes ---------------- */

#include "standard.h"

/* ---------- Function Prototypes ---------- */

/* None */

/* ----------- Global Variables ------------ */

/* None */

/* -------- Function Implementations ------- */

int32_t strToInt(const char *str) {
    uint32_t len      = strlen(str);
    int32_t  result   = 0;
    bool_t   negative = FALSE;

    for (uint32_t i = 0; i != len; i++) {
        if (str[i] == '-') {
            negative = TRUE;
        }

        if (str[i] >= '0' && str[i] <= '9') {
            result += (str[i] - '0') * len;
        }
    }

    if (negative == TRUE) {
        result *= -1;
    }

    return result;
}

// inline void vaArgs_start(vaArg_t **arg, const char *str) {
//     *arg = str + strlen(str);
// }

// inline void vaArgs_next(vaArg_t *arg, uint32_t argSize) {
//     arg += argSize;
// }

// void vaArgs_end(vaArg_t *arg) {
// }
