/* --------------- Includes ---------------- */

#include "Strings.h"

/* ---------- Function Prototypes ---------- */

static void       print(const char *str);

/* ----------- Global Variables ------------ */

const char *const textBuffer = (char *)0xB8000;
uint32_t          currX      = 0;

/* -------- Function Implementations ------- */

uint32_t          strlen(const char *str) {
             uint32_t strSize = 0;
             if (str != NULL) {
                 for (uint32_t i; str[i] != '\0'; i++) {
                     strSize++;
        }
    }
             return strSize;
}

void printf(const char *str, ...) {
    if (str == NULL) {
        return;
    }

    // vaArg_t *args;

    // vaArgs_start(&args, str);

    for (int i = 0 ; str[i] != '\0'; i++) {
        if (str[i] != '%') {
            printChar(*str);
        } else {
			i++;
            switch (str[i]) {
                case 'd': {
                    int i = VA_ARGS_NEXT(args, int);
                    printf("%d\n", i);
                    break;
                }
                case 'c': {
                    // A 'char' variable will be promoted to 'int'
                    // A character literal in C is already 'int' by itself
                    int c = VA_ARGS_NEXT(args, int);
                    printf("%c\n", c);
                    break;
                }
                case 'f': {
                    double d = VA_ARGS_NEXT(args, double);
                    printf("%f\n", d);
                    break;
                }
				// case '!': {
				// 	colour_t = 0;
				// }
				// case '#': {
				// 	colour_t = 0;
				// }
				// case '?': {
				// 	colour_t = 0;
				// }
                default: {
                    printChar(str[i]);
                }
            }

        }
    }
    va_end(args);
}

void print(const char *str) {
}

void printChar(const char letter) {
    // Write the string to the top-left of the screen
    if (letter != '\0') {
        vga_buffer[currX * 2]     = str[i]; // The character
        vga_buffer[currX * 2 + 1] = 0x0A;   // Color: Light Green (0x0A) on Black (0x0)
    }
}
