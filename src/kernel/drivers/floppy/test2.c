#include "test2.h"


void another_func(void){
    volatile unsigned short *VGA = (volatile unsigned short*)0xB8000;
    VGA[13*80+40] = (0x0F << 8) | 'B';
}