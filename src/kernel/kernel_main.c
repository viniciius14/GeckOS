#include "utils.h"

uint16_t *mem = (uint16_t *)0xB8000;

static uint8_t cursor_x = 0;
static uint8_t cursor_y = 0;

void print_char(char letter) {
    uint8_t  attributeByte = (0 << 4) | (0x0F & 0x0F);

    uint16_t *location = mem + (cursor_y * 80 + cursor_x);
    *location = letter | (attributeByte << 8);
    cursor_x++;
}

void print_string(char * arr) {
    uint32_t i = 0;
    while(arr[i]) {
        print_char(arr[i++]);
    }
}


void kernel_main(void) {
    for(uint16_t i = 0; i != 10000 ; i++){
        mem[i] = "A";
    }

    for (;;){}
}