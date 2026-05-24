/* --------------- Includes ---------------- */

#include "keyboard.h"

/* ---------- Function Prototypes ---------- */

/* None */

/* ----------- Global Variables ------------ */

static const Char keyboardLayoutPT[58] = {
    KEY_NULL, KEY_NULL, '1',      '2',      '3',      '4',           '5',      '6',      '7',
    '8',      '9',      '0',      KEY_NULL, KEY_NULL, KEY_BACKSPACE, KEY_TAB,  'q',      'w',
    'e',      'r',      't',      'y',      'u',      'i',           'o',      'p',      KEY_NULL,
    KEY_NULL, '\n',     KEY_NULL, 'a',      's',      'd',           'f',      'g',      'h',
    'j',      'k',      'l',      KEY_NULL, KEY_NULL, KEY_NULL,      KEY_NULL, KEY_NULL, 'z',
    'x',      'c',      'v',      'b',      'n',      'm',           KEY_NULL, KEY_NULL, KEY_NULL,
    KEY_NULL, KEY_NULL, KEY_NULL, ' '
};

Char currKey = 0;

/* -------- Function Implementations ------- */

void InitKeyboard(void) {
    /* Clear out keyboard buffer */
    while (InByte(0x64) & 1) {
        InByte(0x60);
    }

    RegisterInterruptHandler(E_KEYBOARD_INT, (HandlerFn)KeyboardHandler);
}

void KeyboardHandler(const CpuState *cpuState) {
    (void)cpuState;
    Ubyte tempKey = InByte(PS2_DATA_PORT);

    // Only process key presses (Ignore break codes where bit 7 is set)
    if (!(tempKey & 0x80)) {
        
        // Ensure we don't read out of bounds of our layout array
        if (tempKey < 0x3A) { 
            currKey = keyboardLayoutPT[tempKey];
        } else {
            currKey = keyboardLayoutPT[0]; // Fallback/Unknown
        }

        // Only print if it's a valid printable character
        if (currKey != 0) {
            PrintChar(currKey);
        }
    }
}
