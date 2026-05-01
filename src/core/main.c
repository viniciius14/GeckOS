/* --------------- Includes ---------------- */

#include "strings.h"

/* ---------- Function Prototypes ---------- */

/* None */

/* ----------- Global Variables ------------ */

/* None */

/* -------- Function Implementations ------- */

// cppcheck-suppress unusedFunction
void KernelMain(void) {
    // Pointer to the start of the VGA text buffer
    char *vga_buffer = (char *)0xb8000;
    // Each character on screen takes 2 bytes: [ASCII Char][Attribute/Color]
    // Console_init();
    // Console_printString(VGA_WHITE, "ABC");

    const char  *str = "Hello from GeckOS!";
    unsigned int i   = 0;
    unsigned int j   = 0;

    // Clear the screen (optional, but good practice)
    // 80 columns * 25 lines * 2 bytes per character = 4000 bytes
    while (j < 80 * 25 * 2) {
        vga_buffer[j]     = ' ';  // Blank character
        vga_buffer[j + 1] = 0x07; // Light grey on black background
        j                 = j + 2;
    }

    // Write the string to the top-left of the screen
    while (str[i] != '\0') {
        vga_buffer[i * 2]     = str[i]; // The character
        vga_buffer[i * 2 + 1] = 0x0A;   // Color: Light Green (0x0A) on Black (0x0)
        i++;
    }
}
