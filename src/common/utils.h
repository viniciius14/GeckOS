#ifndef __UTILS_H
#define __UTILS_H

/* ---------------- Defines ---------------- */

#define PACKED              __attribute__((packed))
#define INTERRUPT           __attribute__((interrupt))
#define NORETURN            __attribute__((noreturn))
#define WEAK                __attribute__((weak))
#define INLINE              __attribute__((always_inline))
#define NOINLINE            __attribute__((noinline))
#define ALIGNED(alignment)  __attribute__((aligned(alignment)))
#define SECTION(section)    __attribute__((section(section)))

#define STATIC_ASSERT(cond) _Static_assert(cond, #cond "failed at" __LINE__ "of file" __FILE__)
#define UNREACHABLE()       __builtin_unreachable()

#define STI                 __asm__ __volatile__("sti")
#define CLI                 __asm__ __volatile__("cli")
#define ASM                 __asm__ __volatile__

#define MIN(_x, _y)         (_x < _y ? _x : _y)
#define MAX(_x, _y)         (_x > _y ? _x : _y)
#define ABS(x)              ((x) < 0 ? -(x) : (x))
#define SIGN(x)             ((x) < 0 ? -1 : ((x) > 0 ? 1 : 0))

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
#ifdef BITS_64
typedef unsigned long long  uint64_t;
#endif

typedef char                int8_t;
typedef short int           int16_t;
typedef int                 int32_t;
typedef long long           int64_t;

#ifdef BITS_64
typedef uint64_t            uintptr_t;
#else
typedef uint32_t            uintptr_t;
#endif

/* ---------- Function prototypes ---------- */

/* First function that's ran */
void _kernel_main(void);

#endif /* __UTILS_H */