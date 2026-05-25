#ifndef STANDARD_H
#define STANDARD_H

/* --------------- Includes ---------------- */

/* None */

/* ---------------- Defines ---------------- */

#ifndef NULL
#define NULL ((void *)0)
#endif

#define TRUE                   (1)
#define FALSE                  (0)

#define PACKED                 __attribute__((packed))
#define INTERRUPT              __attribute__((interrupt))
#define NORETURN               __attribute__((noreturn))
#define WEAK                   __attribute__((weak))
#define INLINE                 __attribute__((always_inline)) inline
#define NO_INLINE              __attribute__((noinline))
#define NO_DISCARD             __attribute__((warn_unused_result))
#define ALIGNED(_alignment)    __attribute__((aligned(_alignment)))
#define SECTION(_section)      __attribute__((section(_section)))

#define VA_LIST                __builtin_va_list
#define VA_START(_arg, _stack) __builtin_va_start(_arg, _stack)
#define VA_END(_arg)           __builtin_va_end(_arg)

#define STRINGIFY(_x)          (#_x)
#define CONCAT(_x, _y)         (_x##_y)

#define STATIC_ASSERT(_cond)                                                                       \
    _Static_assert(_cond, #_cond " failed at line " TOSTRING(__LINE__) " of file " __FILE__)

#define UNREACHABLE()        __builtin_unreachable()

#define STI()                __asm__ __volatile__("sti")
#define CLI()                __asm__ __volatile__("cli")
#define ASM                  __asm__ __volatile__

#define BIT(_n)              (1ULL << (_n))
#define BIT_SET(_x, _mask)   ((_x) |= (_mask))
#define BIT_CLEAR(_x, _mask) ((_x) &= ~(_mask))
#define BIT_FLIP(_x, _mask)  ((_x) ^= (_mask))
#define BIT_TEST(_x, _mask)  ((_x) & (_mask))

#define ROUND_UP(_x, _ali)   ((_x + _ali) & ~_ali)
#define ROUND_DOWN(_x, _ali) (_x & ~_ali)
#define ALIGN(_x, _ali)      ((_x + ((_ali / 2) + 1)) & (_ali - 1))

#define MAX_UINT08           (0xFF)
#define MAX_UINT16           (0xFFFF)
#define MAX_UINT32           (0xFFFFFFFF)
#define MAX_UINT64           (0xFFFFFFFFFFFFFFFF)

#define MAX_INT08            (0x7F)
#define MAX_INT16            (0x7FFF)
#define MAX_INT32            (0x7FFFFFFF)
#define MAX_INT64            (0x7FFFFFFFFFFFFFFF)

#define MIN_INT08            (0x80)
#define MIN_INT16            (0x8000)
#define MIN_INT32            (0x80000000)
#define MIN_INT64            (0x8000000000000000)

#define MAX_FLOAT32          (3.402823466e+38f)
#define MAX_FLOAT64          (1.7976931348623158e+308f)

#define MIN_FLOAT32          (1.175494351e-38f)
#define MIN_FLOAT64          (2.2250738585072014e-308f)

#define KB(_n)               ((_n) * 1024)
#define MB(_n)               (KB(_n) * 1024)
#define BITS_IN_BYTE         (8)

/* ----------------- Types ----------------- */

/* @TODO: Add unsigned long and long */

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

#if defined(BITS64)
typedef Ulong UintPtr;
typedef Long  IntPtr;
#else
typedef Uint UintPtr;
typedef Int  IntPtr;
#endif

/* ---------- Function prototypes ---------- */

/* None */

#endif /* STANDARD_H */
