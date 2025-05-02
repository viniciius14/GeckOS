/* --------------- Includes ---------------- */

#include "utils.h"
#include "memory.h"

/* ---------- Function Prototypes ---------- */

void _kernel_main(void);

/* ----------- Global Variables ------------ */

/* None */

/* -------- Function Implementations ------- */


uint16_t *video_mem = (uint16_t *)0xB8000;
static uint8_t cursor_x = 0;
static uint8_t cursor_y = 0;
void sc_clear(void) {
    MemSet(video_mem, 0, 10000);
}
void k_char(char letter) {
    if (letter == '\n') {
        cursor_y++;
        cursor_x = 0;
        if (cursor_y > 25) {
            sc_clear();
            cursor_y = 0;
        }
    }
    else {
        uint8_t  attributeByte = (0 << 4) | (0x0F & 0x0F);
        uint16_t *location = video_mem + (cursor_y * 80 + cursor_x);
        *location = letter | (attributeByte << 8);
        cursor_x++;
    }
}
void k_print(char *arr) {
    uint32_t i = 0;
    while(arr[i]) {
        k_char(arr[i++]);
    }
}

void _kernel_main(void) {
    k_print("pirolito");
}
