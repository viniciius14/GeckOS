#ifndef __UTILS_H
#define __UTILS_H

/* ---------------- Defines ---------------- */

#define PACKED                  __attribute__((packed))
#define INTERRUPT               __attribute__((interrupt))
#define NORETURN                __attribute__((noreturn))
#define WEAK                    __attribute__((weak))
#define INLINE                  __attribute__((always_inline))
#define NO_INLINE               __attribute__((noinline))
#define NO_DISCARD              __attribute__((warn_unused_result))
#define ALIGNED(_alignment)     __attribute__((aligned(_alignment)))
#define SECTION(_section)        __attribute__((section(_section)))

#define STATIC_ASSERT(_cond)    _Static_assert(_cond, #_cond "failed at" __LINE__ "of file" __FILE__)
#define UNREACHABLE()           __builtin_unreachable()

#define STI                     __asm__ __volatile__("sti")
#define CLI                     __asm__ __volatile__("cli")
#define ASM                     __asm__ __volatile__

#define BIT(_n)                 (1ULL << (_n))
#define BIT_SET(_x, _mask)      ((_x) |=  (_mask))
#define BIT_CLEAR(_x, _mask)    ((_x) &= ~(_mask))
#define BIT_FLIP(_x, _mask)     ((_x) ^=  (_mask))
#define BIT_TEST(_x, _mask)     ((_x) &   (_mask))

#define NULL                    ((void*) 0)

#define MAX_UINT8  			    (0xFF)
#define MAX_UINT16 			    (0xFFFF)
#define MAX_UINT32 			    (0xFFFFFFFF)
#define MAX_UINT64 			    (0xFFFFFFFFFFFFFFFF)

#define MAX_INT8   			    (0x7F)
#define MAX_INT16  			    (0x7FFF)
#define MAX_INT32  			    (0x7FFFFFFF)
#define MAX_INT64  			    (0x7FFFFFFFFFFFFFFF)

#define MIN_INT8   			    (0x80)
#define MIN_INT16  			    (0x8000)
#define MIN_INT32  			    (0x80000000)
#define MIN_INT64  			    (0x8000000000000000)

#define MAX_FLOAT32             (3.402823466e+38f)
#define MAX_FLOAT64             (1.7976931348623158e+308f)

#define MIN_FLOAT32             (1.175494351e-38f)
#define MIN_FLOAT64             (2.2250738585072014e-308f)

/* ----------------- Types ----------------- */

typedef unsigned char           uint8_t;
typedef unsigned short          uint16_t;
typedef unsigned int            uint32_t;
typedef unsigned long long      uint64_t;

typedef char                    int8_t;
typedef short int               int16_t;
typedef int                     int32_t;
typedef long long               int64_t;

typedef float                   float32_t;
typedef double                  float64_t;

/* ---------- Function prototypes ---------- */

/* First function that's ran */
void _kernel_main(void);

#endif /* __UTILS_H */
