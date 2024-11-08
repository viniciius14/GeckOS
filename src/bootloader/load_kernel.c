#include "load_kernel.h"


void my_func(void){
	uint16_t *mem = (uint16_t *)0xB8000;
	mem[0] = 'L';
	mem[2] = 'O';
	mem[4] = 'A';
	mem[6] = 'D';
}


