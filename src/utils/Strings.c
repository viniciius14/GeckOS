/* --------------- Includes ---------------- */

#include "Strings.h"

/* ---------- Function Prototypes ---------- */

static void printChar(const char letter);

/* ----------- Global Variables ------------ */

char *const textBuffer = (char *)0xB8000;
uint32_t    currX      = 0;
uint8_t     currColour = 0x0A;

/* -------- Function Implementations ------- */

// @TODO: Add colour support for this file

uint32_t strlen(const char *str) {
    uint32_t strSize = 0;
    if (str != NULL) {
        for (uint32_t i = 0; str[i] != '\0'; i++) {
            strSize++;
        }
    }
    return strSize;
}

void print(const char *str) {
    if (str == NULL) {
        return;
    }
    uint32_t i = 0;
    while (str[i] != '\0') {
        textBuffer[i * 2]     = str[i]; // The character
        textBuffer[i * 2 + 1] = 0x0A;   // Color: Light Green (0x0A) on Black (0x0)
        i++;
    }
    (void)printChar;
}

void printChar(const char letter) {
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

// @TODO: Implement me
void printInteger(int num) {
    print("Integer");
    (void)num;
}

// @TODO: Implement me
void printDouble(double num) {
    print("Double");
    (void)num;
}

// @TODO: Implement me
void printHex(uint64_t num) {
    print("Hex");
    (void)num;
}
