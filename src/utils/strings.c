/* --------------- Includes ---------------- */

#include "strings.h"

/* ---------- Function Prototypes ---------- */

static void PrintChar(Char letter);

/* ----------- Global Variables ------------ */

static Uint                 cursorPos  = 0;
static volatile Char *const textBuffer = (Char *)0xB8000;
static Ubyte                currColour = 0x0A;

/* -------- Function Implementations ------- */

// @TODO: Add colour support for this file

void PrintString(const Char *format, ...) {
    if (format == NULL) {
        return;
    }

    __builtin_va_list args;
    __builtin_va_start(args, format); // Initialize here!

    VarArgPrint(format, args); // Pass it safely here

    __builtin_va_end(args); // Clean up here
}

Int StrToInt(const Char *str) {
    Uint len      = StrLen(str);
    Int  result   = 0;
    Bool negative = FALSE;

    for (Uint i = 0; i != len; i++) {
        if (str[i] == '-') {
            negative = TRUE;
        }

        if (str[i] >= '0' && str[i] <= '9') {
            result += (str[i] - '0') * len;
        }
    }

    if (negative == TRUE) {
        result *= -1;
    }

    return result;
}

Uint StrLen(const Char *str) {
    Uint strSize = 0;
    if (str != NULL) {
        for (Uint i = 0; str[i] != '\0'; i++) {
            strSize++;
        }
    }
    return strSize;
}

void StrReverse(Char *str) {
    Uint start = 0;
    Uint end   = StrLen(str) - 1;

    while (start < end) {
        Char temp  = str[start];
        str[start] = str[end];
        str[end]   = temp;
        start++;
        end--;
    }
}

Char *IntToStr(Long num, Char *str, Uint base) {
    Int i          = 0;
    Int isNegative = 0;

    if (num == 0) {
        str[i++] = '0';
        str[i]   = '\0';
        return str;
    }

    if (num < 0 && base == 10) {
        isNegative = 1;
        num        = -num;
    }

    /* @TODO: Not happy about this, if possible use a nicer solution that works for both 32 and 64
     * bit */
    while (num != 0) {
        UintPtr rem = (UintPtr)num % base;
        str[i++]    = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
        num         = (UintPtr)num / base;
    }

    if (isNegative) {
        str[i++] = '-';
    }

    str[i] = '\0';
    StrReverse(str);
    return str;
}

void VarArgPrint(const Char *format, __builtin_va_list args) {
    for (const Char *p = format; *p != '\0'; p++) {
        if (*p == '%') {
            p++;

            Uint isLong = 0;
            // Check for long modifier (%ld, %llx)
            if (*p == 'l') {
                isLong = 1;
                p++;
                if (*p == 'l') {
                    isLong = 2;
                    p++;
                }
            }

            switch (*p) {
                case 'c': {
                    // Characters are promoted to Int when passed through '...'
                    Char c = (Char) __builtin_va_arg(args, Int);
                    PrintChar(c);
                    break;
                }
                case 's': {
                    Char *s = __builtin_va_arg(args, Char *);
                    if (!s) {
                        s = "(null)";
                    }

                    while (*s) {
                        PrintChar(*s);
                        s++;
                    }
                    break;
                }
                case 'd': {
                    Long d;
                    if (isLong == 2) {
                        d = __builtin_va_arg(args, Long);
                    } else if (isLong == 1) {
                        d = __builtin_va_arg(args, long);
                    } else {
                        d = __builtin_va_arg(args, Int);
                    }

                    Char buf[64];

                    IntToStr(d, buf, 10);

                    for (Uint i = 0; buf[i] != '\0'; i++) {
                        PrintChar(buf[i]);
                    }

                    break;
                }
                case 'x': {
                    Ulong x;
                    if (isLong == 2) {
                        x = __builtin_va_arg(args, Ulong);
                    } else if (isLong == 1) {
                        x = __builtin_va_arg(args, unsigned long);
                    } else {
                        x = __builtin_va_arg(args, Uint);
                    }

                    Char buf[64];
                    IntToStr(x, buf, 16);
                    for (Int i = 0; buf[i] != '\0'; i++)
                        PrintChar(buf[i]);
                    break;
                }
                case 'p': {
                    void *ptr = __builtin_va_arg(args, void *);
                    Char  buf[64];
                    IntToStr((Ulong)((UintPtr)ptr), buf, 16);

                    PrintChar('0');
                    PrintChar('x');

                    for (Int i = 0; buf[i] != '\0'; i++) {
                        PrintChar(buf[i]);
                    }

                    break;
                }
                case '%': {
                    PrintChar('%');
                    break;
                }
                default: {
                    PrintChar('%');
                    PrintChar(*p);
                    break;
                }
            }
        } else {
            PrintChar(*p);
        }
    }
}

static void PrintChar(Char letter) {
    if (letter == '\n') {
        cursorPos += CHARS_PER_LINE - (cursorPos % CHARS_PER_LINE);
    } else {
        textBuffer[cursorPos * 2]     = letter;
        textBuffer[cursorPos * 2 + 1] = currColour;
        cursorPos++;
    }
}
