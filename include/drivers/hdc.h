#ifndef __HDC_H
#define __HDC_H

/* ------------------------------------------- Defines ------------------------------------------- */
#define HDC_BASE_ADDR 0x1F0

#define HDC_DATA				HDC_BASE_ADDR + 0
#define HDC_ERROR				HDC_BASE_ADDR + 1
#define HDC_FEATURES			HDC_BASE_ADDR + 1
#define HDC_SECTOR_COUNT		HDC_BASE_ADDR + 2
#define HDC_SECTOR_NUMBER		HDC_BASE_ADDR + 3
#define HDC_CYLINDER_LOW		HDC_BASE_ADDR + 4
#define HDC_CYLINDER_HIGH		HDC_BASE_ADDR + 5
#define HDC_DRIVE_HEAD			HDC_BASE_ADDR + 6
#define HDC_STATUS				HDC_BASE_ADDR + 7
#define HDC_COMMAND				HDC_BASE_ADDR + 7
/* -------------------------------------------- Types -------------------------------------------- */

/* ------------------------------------- Function prototypes ------------------------------------- */

#endif /* __HDC_H */
