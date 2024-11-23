#include "load_kernel.h"

// #ifndef KERNEL_SECTORS
// 	#error KERNEL_SECTORS not defined!
// #endif

volatile char* video = (volatile char*)0xB8000;
const char* str = "Found kernel beggining.\0";

uint16_t num = 10;
#define TARGET_ADDR 0x100000

void _load_kernel(void) {
	uintptr_t *kernel_addr = find_sector();

	/* Move the kernel somewhere else */
	memcpy((void *)TARGET_ADDR, kernel_addr, KERNEL_SECTORS * 512);


}


#define END_MARKER 0x1BADB001DEADBEEF

#define VIDEO_MEMORY 0xB8000        // VGA text mode video memory address
#define WHITE_ON_BLACK 0x0F         // VGA attribute byte for white text on black background
#define TARGET_ADDRESS 0x7E00       // Start address to check sectors
#define SECTOR_SIZE 512             // Assuming 512 bytes per sector
#define END_MARKER_1      // First marker to look for
#define END_MARKER_2      // Second marker after END_MARKER_1
#define VIDEO_MEMORY 0xB8000        // VGA text mode video memory address
#define WHITE_ON_BLACK 0x0F         // VGA attribute byte for white text on black background
#define MAX_ROWS 25                 // VGA screen has 25 rows
#define MAX_COLS 80                 // VGA screen has 80 columns
#define BYTES_PER_CHAR 2            // Each character in VGA text mode has 2 bytes
// Function prototypes


// Entry point

// Print a string to the screen
void print(const char* str) {
    while (*str != '\0') {
		if(*str == '\n') {
            // Calculate current row and go to the beginning of the next line
            int offset = (video - (volatile char*) VIDEO_MEMORY) / BYTES_PER_CHAR;
            int col = offset % MAX_COLS;

            // Move to the start of the next row
            video += (MAX_COLS - col) * BYTES_PER_CHAR;

		}
        *video++ = *str++;          // Write character
        *video++ = WHITE_ON_BLACK;  // Set color
    }
}

// Convert integer to string in a specified base (10 for decimal, 16 for hex)
void itoa(int value, char* str, int base) {
    char* p = str;
    char* p1, * p2;
    unsigned int uvalue = (unsigned int) value;

    // Generate digits in reverse order
    do {
        int digit = uvalue % base;
        *p++ = (digit < 10) ? '0' + digit : 'A' + (digit - 10);
        uvalue /= base;
    } while (uvalue > 0);

    // Terminate string with null character
    *p = '\0';

    // Reverse the string in place
    p1 = str;
    p2 = p - 1;
    while (p1 < p2) {
        char temp = *p1;
        *p1 = *p2;
        *p2 = temp;
        p1++;
        p2--;
    }
}

// Check each sector starting from 0x7E00 for END_MARKER_1 followed by END_MARKER_2
uintptr_t* find_sector() {
    uintptr_t* address = (uintptr_t*) TARGET_ADDRESS;
    char buffer[16];
    uint8_t sector = 0;

    while (1) {
        // Print sector infokernel_addr
        print("Sector ");
        itoa(sector, buffer, 10);
        print(buffer);
        print(" top value (hex): 0x");
        itoa(*address, buffer, 16);
        print(buffer);
        print("\n");

        // Check for the target markers
        if (*address == END_MARKER) {
			print("next value: 0x");
			itoa(*(address + 1), buffer, 16);
			print(buffer);
			print("\n");
            return address + 1;
        }

        // Move to the next sector
        address += SECTOR_SIZE / sizeof(uintptr_t);  // Advance by SECTOR_SIZE bytes
        sector++;
    }

	return 0;
}
