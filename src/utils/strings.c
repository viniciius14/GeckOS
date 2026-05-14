/* --------------- Includes ---------------- */

#include "strings.h"

/* ---------- Function Prototypes ---------- */

static void PrintChar(const char letter);

/* ----------- Global Variables ------------ */

Char *const textBuffer = (char *)0xB8000;
Uint        currX      = 0;
Ubyte       currColour = 0x0A;

/* -------- Function Implementations ------- */

void PrintString(const char *str) {
    if (str == NULL) {
        return;
    }

    Uint i = 0;
    while (str[i] != '\0') {

        if (str[i] == '\n') {
            currX = ((currX / CHARS_PER_LINE) + 1) * CHARS_PER_LINE;
            i++;
            continue;
        }

        textBuffer[currX * 2]     = str[i]; // The character
        textBuffer[currX * 2 + 1] = 0x0A;   // Color: Light Green (0x0A) on Black (0x0)
        currX++;
        i++;
    }
    (void)PrintChar;
}

Int StrToInt(const char *str) {
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

// @TODO: Add colour support for this file

Uint StrLen(const char *str) {
    Uint strSize = 0;
    if (str != NULL) {
        for (Uint i = 0; str[i] != '\0'; i++) {
            strSize++;
        }
    }
    return strSize;
}

#define MAX_CHARS_INT (10)
// @TODO: Implement me
void PrintInt(Int num) {
    Char buffer[MAX_CHARS_INT] = { 0 };
    Int  i                     = MAX_CHARS_INT - 1;

    /* Handle the case when the num is 0 separately */
    if (num == 0) {
        buffer[i] = '0';
        i--;
    } else {
        while (num > 0) {
            buffer[i] = '0' + (num % 10);
            num /= 10;
            i--;
        }
    }

    /* Move the characters to the beginning of the buffer */
    for (Int j = i + 1; j < MAX_CHARS_INT; j++) {
        buffer[j - i - 1] = buffer[j];
    }

    /* Null-terminate the string */
    buffer[MAX_CHARS_INT - i - 1] = '\0';

    PrintString(buffer);
}

// @TODO: Implement me
void PrintDouble(double num) {
    PrintString("Double");
    (void)num;
}

// @TODO: Implement me
void PrintHex(Ulong num) {
    PrintString("Hex");
    (void)num;
}

void PrintChar(const char letter) {
    if (letter != '\0') {
        if (letter == '\n') {
            // @TODO Jump to the beginning of the next row
            // currX +=;
        } else {
            textBuffer[currX++ * 2]     = letter;
            textBuffer[currX++ * 2 + 1] = currColour; // Colour
            currX++;
        }
    }
}
