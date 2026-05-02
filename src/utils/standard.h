#ifndef __STANDARD_H
#define __STANDARD_H

/* --------------- Includes ---------------- */

/* None */

/* ---------------- Defines ---------------- */

#ifndef NULL
#define NULL ((void *)0)
#endif

#define TRUE                (1)
#define FALSE               (0)

#define PACKED              __attribute__((packed))
#define INTERRUPT           __attribute__((interrupt))
#define NORETURN            __attribute__((noreturn))
#define WEAK                __attribute__((weak))
#define INLINE              __attribute__((always_inline)) inline
#define NO_INLINE           __attribute__((noinline))
#define NO_DISCARD          __attribute__((warn_unused_result))
#define ALIGNED(_alignment) __attribute__((aligned(_alignment)))
#define SECTION(_section)   __attribute__((section(_section)))

#define STRINGIFY(x)        #x
#define TOSTRING(x)         STRINGIFY(x)

#define STATIC_ASSERT(_cond)                                                                       \
    _Static_assert(_cond, #_cond " failed at line " TOSTRING(__LINE__) " of file " __FILE__)

#define UNREACHABLE()           __builtin_unreachable()

#define STI()                   __asm__ __volatile__("sti")
#define CLI()                   __asm__ __volatile__("cli")
#define ASM                     __asm__ __volatile__

#define BIT(_n)                 (1ULL << (_n))
#define BIT_SET(_x, _mask)      ((_x) |= (_mask))
#define BIT_CLEAR(_x, _mask)    ((_x) &= ~(_mask))
#define BIT_FLIP(_x, _mask)     ((_x) ^= (_mask))
#define BIT_TEST(_x, _mask)     ((_x) & (_mask))

/* width of stack == width of int */
#define STACKITEM               (int)

/* round up width of objects pushed on stack. The expression before the
& ensures that we get 0 for objects of size 0. */
#define VA_SIZE(_type)          ((sizeof(_type) + sizeof(STACKITEM) - 1) & ~(sizeof(STACKITEM) - 1))

/* &(_lastArg) points to the LEFTMOST argument of the function call (before the ...) */
#define VA_START(_ap, _lastArg) (_ap = ((VaList) & (_lastArg) + VA_SIZE(_lastArg)))

#define VA_ARG(_ap, _type)      (_ap += VA_SIZE(_type), *((_type *)(_ap - VA_SIZE(_type))))

#define MAX_UINT08              (0xFF)
#define MAX_UINT16              (0xFFFF)
#define MAX_UINT32              (0xFFFFFFFF)
#define MAX_UINT64              (0xFFFFFFFFFFFFFFFF)

#define MAX_INT08               (0x7F)
#define MAX_INT16               (0x7FFF)
#define MAX_INT32               (0x7FFFFFFF)
#define MAX_INT64               (0x7FFFFFFFFFFFFFFF)

#define MIN_INT08               (0x80)
#define MIN_INT16               (0x8000)
#define MIN_INT32               (0x80000000)
#define MIN_INT64               (0x8000000000000000)

#define MAX_FLOAT32             (3.402823466e+38f)
#define MAX_FLOAT64             (1.7976931348623158e+308f)

#define MIN_FLOAT32             (1.175494351e-38f)
#define MIN_FLOAT64             (2.2250738585072014e-308f)

/* ----------------- Types ----------------- */

typedef unsigned char      Ubyte;
typedef unsigned short     Ushort;
typedef unsigned int       Uint;
typedef unsigned long long Ulong;
typedef char               Byte;
typedef short int          Short;
typedef int                Int;
typedef long long          Long;
typedef float              Float;
typedef double             Double;
typedef unsigned char      Bool;
typedef char               Char;

typedef unsigned char *VaList;

/* ---------- Function prototypes ---------- */

void PrintString(const char *str);
Int  StrToInt(const char *str);

#endif /* __STANDARD_H */
