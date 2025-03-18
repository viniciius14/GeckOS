#ifndef __FDC_H
#define __FDC_H

#include "utils.h"
#include "memory.h"
#include "io.h"

/* ---------------- Defines ---------------- */

#define FDC_BASE_ADDR                   0x03F0

#define FDC_STATUS_A                    0x03F0
#define FDC_STATUS_B                    0x03F1
#define FDC_DIGITAL_OUT                 0x03F2
#define FDC_TAPE_DRIVE                  0x03F3
#define FDC_MAIN_STATUS                 0x03F4
#define FDC_DATA_RATE_SEL               0x03F4
#define FDC_DATA_FIFO                   0x03F5
#define FDC_DIGITAL_IN                  0x03F7
#define FDC_CONFIG_CTRL                 0x03F7

#define FDC_DMA_CHANNEL                 2
#define FDC_IRQ                         6

#define FDC_CMD_READ_TRACK              2	    /* generates IRQ6 */
#define FDC_CMD_SPECIFY                 3       /* set drive parameters */
#define FDC_CMD_SENSE_DRIVE_STATUS      4
#define FDC_CMD_WRITE_DATA              5       /* write to the disk */
#define FDC_CMD_READ_DATA               6       /* read from the disk */
#define FDC_CMD_RECALIBRATE             7       /* seek to cylinder 0 */
#define FDC_CMD_SENSE_INTERRUPT         8       /* ack IRQ6, get status of last command */
#define FDC_CMD_WRITE_DELETED_DATA      9
#define FDC_CMD_READ_ID                 10	    /* generates IRQ6 */
#define FDC_CMD_READ_DELETED_DATA       12
#define FDC_CMD_FORMAT_TRACK            13
#define FDC_CMD_DUMPREG                 14
#define FDC_CMD_SEEK                    15      /* seek both heads to cylinder X */
#define FDC_CMD_VERSION                 16	    /* used during initialization, once */
#define FDC_CMD_SCAN_EQUAL              17
#define FDC_CMD_PERPENDICULAR_MODE      18	    /* used during initialization, once, maybe */
#define FDC_CMD_CONFIGURE               19      /* set controller parameters */
#define FDC_CMD_LOCK                    20      /* protect controller params from a reset */
#define FDC_CMD_VERIFY                  22
#define FDC_CMD_SCAN_LOW_OR_EQUAL       25
#define FDC_CMD_SCAN_HIGH_OR_EQUAL      29

/* ----------------- Types ----------------- */



/* ---------- Function prototypes ---------- */

uint8_t fdc_init(void);
uint8_t fdc_read(uint16_t lba, uint8_t *buffer);
uint8_t fdc_write(uint16_t lba, uint8_t *buffer);
uint8_t fdc_specify(void);
uint8_t fdc_configure(void);
uint8_t fdc_recalibrate(void);
uint8_t fdc_seek(uint16_t lba);

uint8_t check_st0(uint8_t st0);
uint8_t check_st1(uint8_t st1);
uint8_t check_st2(uint8_t st2);

uint8_t fdc_send_byte(uint8_t byte);
uint8_t fdc_get_byte(uint8_t *byte);

void    fdc_reset(void);
void    fdc_wait_for_interrupt(void);

/* TEMP DELETE LATER */
void print_string(char * arr);

void print_char(char letter);
/* TEMP DELETE LATER */


#endif /* __FDC_H */
