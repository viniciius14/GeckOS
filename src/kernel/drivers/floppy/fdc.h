#ifndef __FDC_H
#define __FDC_H

#include "utils.h"
#include "memory.h"
#include "io.h"

/* ---------------- Defines ---------------- */

#define FDC_BASE_ADDR           (0x03F0)
#define FDC_DMA_CHANNEL         (2)
#define FDC_IRQ                 (6)

/* ----------------- Types ----------------- */

typedef enum fdcRegAddresses {
    FDC_ADDR_STATUS_A           = 0x03F0, /* SRA  - R   */
    FDC_ADDR_STATUS_B           = 0x03F1, /* SRB  - R   */
    FDC_ADDR_DIGITAL_OUT        = 0x03F2, /* DOR  - R/W */
    FDC_ADDR_TAPE_DRIVE         = 0x03F3, /* TDR  - R/W */
    FDC_ADDR_MAIN_STATUS        = 0x03F4, /* MSR  - R   */
    FDC_ADDR_DATA_RATE_SEL      = 0x03F4, /* DSR  - W   */
    FDC_ADDR_DATA_FIFO          = 0x03F5, /* FIFO - R/W */
    FDC_ADDR_DIGITAL_IN         = 0x03F7, /* DIR  - R   */
    FDC_ADDR_CONFIG_CTRL        = 0x03F7  /* CCR  - W   */
}                               fdcRegAddr_e;

typedef const enum fdcCommands {
    FDC_CMD_READ_TRACK          = 2,
    FDC_CMD_SPECIFY             = 3,
    FDC_CMD_SENSE_DRIVE_STATUS  = 4,
    FDC_CMD_WRITE_DATA          = 5,
    FDC_CMD_READ_DATA           = 6,
    FDC_CMD_RECALIBRATE         = 7,
    FDC_CMD_SENSE_INTERRUPT     = 8,
    FDC_CMD_WRITE_DELETED_DATA  = 9,
    FDC_CMD_READ_ID             = 10,
    FDC_CMD_READ_DELETED_DATA   = 12,
    FDC_CMD_FORMAT_TRACK        = 13,
    FDC_CMD_DUMPREG             = 14,
    FDC_CMD_SEEK                = 15,
    FDC_CMD_VERSION             = 16,
    FDC_CMD_SCAN_EQUAL          = 17,
    FDC_CMD_PERPENDICULAR_MODE  = 18,
    FDC_CMD_CONFIGURE           = 19,
    FDC_CMD_LOCK                = 20,
    FDC_CMD_VERIFY              = 22,
    FDC_CMD_SCAN_LOW_OR_EQUAL   = 25,
    FDC_CMD_SCAN_HIGH_OR_EQUAL  = 29
}                               fdcCommands_e;


typedef const volatile struct fdcStatusRegisterA {
    uint8_t dir                 : 1;
    uint8_t wp                  : 1;
    uint8_t indx                : 1;
    uint8_t hdsel               : 1;
    uint8_t trk0                : 1;
    uint8_t step                : 1;
    uint8_t drv2                : 1;
    uint8_t int_pending         : 1; /* State of the 82077AA INTERRUPT pin */
} PACKED                        fdcRegStatusA_s;
STATIC_ASSERT(sizeof(fdcRegStatusA_s) == sizeof(uint8_t));

typedef const volatile struct fdcStatusRegisterB {
    uint8_t mot_en0             : 1; /* Motor bit */
    uint8_t mot_en1             : 1; /* Motor bit */
    uint8_t we                  : 1;
    uint8_t rddata_toggle       : 1; /* Read data toggle */
    uint8_t wrdata_toggle       : 1; /* Write data toggle */
    uint8_t driver_sel          : 1; /* Driver select */
    uint8_t reserved            : 2;
} PACKED                        fdcRegStatusB_s;
STATIC_ASSERT(sizeof(fdcRegStatusB_s) == sizeof(uint8_t));

/* Standard programming practice is to set both MOT ENx and DRIVE SELx bits at the same time. */
typedef volatile struct fdcDigitalOutputRegister {
    uint8_t drive_sel0          : 1;
    uint8_t drive_sel1          : 1;
    uint8_t reset               : 1;
    uint8_t dma_gate            : 1;
    uint8_t mot_en0             : 1;
    uint8_t mot_en1             : 1;
    uint8_t mot_en2             : 1;
    uint8_t mot_en3             : 1;
} PACKED                        fdcRegDigOut_s;
STATIC_ASSERT(sizeof(fdcRegDigOut_s) == sizeof(uint8_t));

typedef volatile struct fdcTapeDriveRegister {
    uint8_t tape_sel0           : 1;
    uint8_t tape_sel1           : 1;
    uint8_t reserved            : 6;
} PACKED                        fdcRegTapeDrv_s;
STATIC_ASSERT(sizeof(fdcRegTapeDrv_s) == sizeof(uint8_t));

typedef const volatile struct fdcMainStatusRegister {
    uint8_t drv0_busy           : 1;
    uint8_t drv1_busy           : 1;
    uint8_t drv2_busy           : 1;
    uint8_t drv3_busy           : 1;
    uint8_t cmd_bsy             : 1;
    uint8_t non_dma             : 1;
    uint8_t dio                 : 1;
    uint8_t rqm                 : 1;
} PACKED                        fdcRegMainStatus_s;
STATIC_ASSERT(sizeof(fdcRegMainStatus_s) == sizeof(uint8_t));

typedef volatile struct fdcDataRateSelectRegister {
    uint8_t drate_sel0          : 1;
    uint8_t drate_sel1          : 1;
    uint8_t precomp0            : 1;
    uint8_t precomp1            : 1;
    uint8_t precomp2            : 1;
    uint8_t reserved            : 1;
    uint8_t power_down          : 1;
    uint8_t sw_reset            : 1;
} PACKED                        fdcRegDataRateSel_s;
STATIC_ASSERT(sizeof(fdcRegDataRateSel_s) == sizeof(uint8_t));

typedef const volatile struct fdcDigitalInputRegister {
    uint8_t reserved            : 7;
    uint8_t dsk_chg             : 1;
} PACKED                        fdcRegDigInp_s;
STATIC_ASSERT(sizeof(fdcRegDigInp_s) == sizeof(uint8_t));

typedef volatile struct fdcConfigurationControlRegister {
    uint8_t drate_sel0          : 1;
    uint8_t drate_sel1          : 1;
    uint8_t reserved            : 6;
} PACKED                        fdcRegConfigCtrl_s;
STATIC_ASSERT(sizeof(fdcRegConfigCtrl_s) == sizeof(uint8_t));

typedef const volatile struct fdcStatusRegister0 {
    uint8_t ds                  : 2; /* The current selected drive */
    uint8_t h                   : 1; /* The current head address */
    uint8_t reserved            : 1;
    uint8_t ec                  : 1; /* Equipment check */
    uint8_t se                  : 1; /* Seek end */
    uint8_t ic                  : 2; /* Interrupt code */
} PACKED                        fdcRegStatus0_s;
STATIC_ASSERT(sizeof(fdcRegStatus0_s) == sizeof(uint8_t));

typedef const volatile struct fdcStatusRegister1 {
    uint8_t ma                  : 1; /* Missing Address mark */
    uint8_t nw                  : 1; /* Not Writable */
    uint8_t nd                  : 1; /* No Data */
    uint8_t reserved            : 1;
    uint8_t or                  : 1; /* Overrun / Underrun */
    uint8_t de                  : 1; /* Data Error */
    uint8_t reserved1           : 1;
    uint8_t en                  : 1; /* End of Cylinder */
} PACKED                        fdcRegStatus1_s;
STATIC_ASSERT(sizeof(fdcRegStatus1_s) == sizeof(uint8_t));

typedef const volatile struct fdcStatusRegister2 {
    uint8_t md                  : 1; /* Missing Data Address Mark */
    uint8_t bc                  : 1; /* Bad Cylinder */
    uint8_t reserved            : 2;
    uint8_t wc                  : 1; /* Wrong Cylinder */
    uint8_t dd                  : 1; /* Data Error in Data Field */
    uint8_t cm                  : 1; /* Control Mark */
    uint8_t reserved1           : 1;
} PACKED                        fdcRegStatus2_s;
STATIC_ASSERT(sizeof(fdcRegStatus2_s) == sizeof(uint8_t));

typedef const volatile struct fdcStatusRegister3 {
    uint8_t ds                  : 2; /* Drive Select */
    uint8_t hd                  : 1; /* Head Address */
    uint8_t reserved            : 1;
    uint8_t t0                  : 1; /* Track 0 */
    uint8_t reserved1           : 1;
    uint8_t wp                  : 1; /* Write Protected */
    uint8_t reserved2           : 1;
} PACKED                        fdcRegStatus3_s;
STATIC_ASSERT(sizeof(fdcRegStatus3_s) == sizeof(uint8_t));

/* ---------- Function prototypes ---------- */

status_e        FdcInit(void);
status_e        FdcRead(const uint16_t lba, uint8_t *buffer);
status_e        FdcWrite(const uint16_t lba, uint8_t *buffer);
void            FdcReset(void);

static void     FdcWaitForRQM(void);
static status_e FdcSpecify(void);
static status_e FdcConfigure(void);
static status_e FdcRecalibrate(void);
static status_e FdcSeek(const uint16_t lba);
static status_e FdcSendByte(const uint8_t byte);
static status_e FdcGetByte(uint8_t *const byte);

static status_e FdcCheckSt0(const fdcRegStatus0_s st0);
static status_e FdcCheckSt1(const fdcRegStatus1_s st1);
static status_e FdcCheckSt2(const fdcRegStatus2_s st2);
static status_e FdcCheckSt3(const fdcRegStatus3_s st3);




/* TEMP DELETE LATER */
void print_string(char * arr);

void print_char(char letter);
/* TEMP DELETE LATER */


#endif /* __FDC_H */
