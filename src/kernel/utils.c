#include "utils.h"

void memset(void *dst, uint8_t value, uint32_t n) {
    uint8_t *d = dst;
    while (n-- > 0) {
        *(d++) = value;
    }
}

void *memcpy(void *dst, const void *src, uint32_t n) {
    uint8_t *d = dst;
    const uint8_t *s = src;

    while (n-- > 0) {
        *(d++) = *(s++);
    }
    return dst;
}

void *memmove(void *dst, const void *src, uint32_t n) {
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


void outb(uint16_t port, uint8_t data){
	ASM("outb %0, %1" : : "a"(data), "Nd"(port));
	return;
}

uint8_t inb(uint16_t port){
	uint8_t res;
	ASM("inb %1, %0" : "=a"(res) : "Nd"(port));
	return res;
}


void outw(uint16_t port, uint16_t value)
{
	ASM("outw %w0, %1" : : "a" (value), "id" (port) );
}

uint16_t inw(uint16_t port){
   uint16_t ret;
   ASM("inw %1, %0" : "=a" (ret) : "dN" (port));
   return ret;
}


void outl(uint16_t port, uint32_t value){
	ASM("outl %%eax, %%dx" :: "d" (port), "a" (value));
}

uint32_t inl(uint16_t port){
   uint32_t ret;
   ASM("inl %1, %0" : "=a" (ret) : "dN" (port));
   return ret;
}

void io_wait(void) {
    ASM("outb %%al, $0x80" : : "a"(0));
}