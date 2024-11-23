#ifndef __UTILS_H
#define __UTILS_H

/* ---------------- Defines ---------------- */

#define PACKED              __attribute__((packed))
#define INTERRUPT           __attribute__((interrupt))

#define STI                 __asm__ __volatile__("sti")
#define CLI                 __asm__ __volatile__("cli")
#define ASM                 __asm__ __volatile__

#define MIN(_x, _y)         (_x < _y ? _x : _y)
#define MAX(_x, _y)         (_x > _y ? _x : _y)

#define MAX_UINT8  			0xFF
#define MAX_UINT16 			0xFFFF
#define MAX_UINT32 			0xFFFFFFFF
#define MAX_UINT64 			0xFFFFFFFFFFFFFFFF

#define MAX_INT8   			0x7F
#define MAX_INT16  			0x7FFF
#define MAX_INT32  			0x7FFFFFFF
#define MAX_INT64  			0x7FFFFFFFFFFFFFFF

#define MIN_INT8   			0x80
#define MIN_INT16  			0x8000
#define MIN_INT32  			0x80000000
#define MIN_INT64  			0x8000000000000000

/* ----------------- Types ----------------- */

typedef unsigned char       uint8_t;
typedef unsigned short      uint16_t;
typedef unsigned int        uint32_t;
typedef unsigned long long  uint64_t;

typedef char                int8_t;
typedef short int           int16_t;
typedef int                 int32_t;
typedef long long           int64_t;

typedef uint64_t            uintptr_t;

/* ---------- Function prototypes ---------- */

/* First function that's ran */
void _kernel_main(void);

/* Sets n bytes of memory to value starting at address dst */
void memset(void *, uint8_t, uint32_t);

/* Copies n bytes of memory from src to dst */
void *memcpy(void *, const void *, uint32_t);

/* Moves n bytes from src to dst */
void *memmove(void *, const void *, uint32_t);

/* Outputs a byte to the specified hardware port */
void outb(uint16_t, uint8_t);

/* Outputs a word to the specified hardware port */
void outw(uint16_t, uint16_t);

/* Gets a byte from the specified hardware port */
uint8_t inb(uint16_t);

/* Gets a word from to the specified hardware port */
uint16_t inw(uint16_t);

void outl(uint16_t port, uint32_t value);

uint32_t inl(uint16_t port);

/* Wait 1 I/O cycle for I/O operation to complete */
void io_wait(void);

#endif /* __UTILS_H */
