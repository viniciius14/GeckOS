#ifndef __LOAD_KERNEL_H
#define __LOAD_KERNEL_H


#include "utils.h"

void _load_kernel(void);
void print(const char* str);
void itoa(int value, char* str, int base);
uint64_t* find_sector();


#endif