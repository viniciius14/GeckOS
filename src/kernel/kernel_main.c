#include "utils.h"

uint16_t *mem = (uint16_t *)0xB8000;

void _kernel_main(void) {
    for(uint16_t i = 0; i != 10000 ; i+=2) {
        *mem++ = 'A';          // Write character
        *mem++ = 0x0F;  // Set color
    }

    for (;;){}
}