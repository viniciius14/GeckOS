#include "io.h"

void outbyte(uint16_t port, uint8_t data){
	ASM("outb %0, %1" : : "a"(data), "Nd"(port));
	return;
}


uint8_t inbyte(uint16_t port){
	uint8_t res;
	ASM("inb %1, %0" : "=a"(res) : "Nd"(port));
	return res;
}


void outword(uint16_t port, uint16_t value)
{
	ASM("outw %w0, %1" : : "a" (value), "id" (port) );
}


uint16_t inword(uint16_t port){
   uint16_t ret;
   ASM("inw %1, %0" : "=a" (ret) : "dN" (port));
   return ret;
}


void io_wait(void) {
    ASM("outb %%al, $0x80" : : "a"(0));
}
