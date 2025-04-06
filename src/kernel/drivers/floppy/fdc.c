#include "fdc.h"


// static fdcRegStatusA_s     *fdcStatA;
// static fdcRegStatusB_s     *fdcStatB;
// static fdcRegDigOut_s      *fdcDigOut;
// static fdcRegTapeDrv_s     *fdcTapeDrv;
// static fdcRegMainStatus_s  *fdcMainStat;
// static fdcRegDataRateSel_s *fdcDataRate;
// static uint8_t             *fifo;
// static fdcRegDigInp_s      *fdcDigIn;
// static fdcRegConfigCtrl_s  *fdcConfigCtrl;



void print_hex(uint8_t num) {
    const char *hex_digits = "0123456789ABCDEF";

    // Print "0x" prefix if you want
    print_char('0');
    print_char('x');

    // Print each nibble from highest to lowest
    for (int i = 1; i >= 0; i--) {
        uint8_t nibble = (num >> (i * 4)) & 0xF;
        print_char(hex_digits[nibble]);
    }
}

void FdcPrintRegs(void) {
    print_string("fdcStatA      = "); print_hex(InByte(FDC_ADDR_STATUS_A));      print_char('\n');
    print_string("fdcStatB      = "); print_hex(InByte(FDC_ADDR_STATUS_B));      print_char('\n');
    print_string("fdcDigOut     = "); print_hex(InByte(FDC_ADDR_DIGITAL_OUT));   print_char('\n');
    print_string("fdcTapeDrv    = "); print_hex(InByte(FDC_ADDR_TAPE_DRIVE));    print_char('\n');
    print_string("fdcMainStat   = "); print_hex(InByte(FDC_ADDR_MAIN_STATUS));   print_char('\n');
    print_string("fdcDataRate   = "); print_hex(InByte(FDC_ADDR_DATA_RATE_SEL)); print_char('\n');
    print_string("fifo          = "); print_hex(InByte(FDC_ADDR_DATA_FIFO));     print_char('\n');
    print_string("fdcDigIn      = "); print_hex(InByte(FDC_ADDR_DIGITAL_IN));    print_char('\n');
    print_string("fdcConfigCtrl = "); print_hex(InByte(FDC_ADDR_CONFIG_CTRL));   print_char('\n');
}

/* TEMP DELETE LATER */
uint16_t *mem = (uint16_t *)0xB8000;
static uint8_t cursor_x = 0;
static uint8_t cursor_y = 0;
void screen_clear(void) {
    MemSet(mem, 0, 10000);
}
void print_string(char * arr) {
    uint32_t i = 0;
    while(arr[i]) {
        print_char(arr[i++]);
    }
}
void print_char(char letter) {
        if (letter == '\n') {
            cursor_y++;
            cursor_x = 0;
            if (cursor_y > 25) {
                screen_clear();
                cursor_y = 0;
            }
        }
        else {
            uint8_t  attributeByte = (0 << 4) | (0x0F & 0x0F);

            uint16_t *location = mem + (cursor_y * 80 + cursor_x);
            *location = letter | (attributeByte << 8);
            cursor_x++;
        }
    }
/* TEMP DELETE LATER */

status_e FdcInit(void) {
    screen_clear();


    /* temp */
    fdcRegStatus3_s temp;
    (void)FdcCheckSt3(temp);
    /* end of temp*/

    uint8_t result = 0;

    FdcReset();

    /* Set datarate to 500Kbps */
    OutByte(FDC_ADDR_DATA_RATE_SEL, 0x0);

    FdcWaitForRQM();

    FdcPrintRegs();

    /* 4 SENSE INTERRUPT STATUS commands need to be issued to clear the status flags for each drive.*/
    for (uint8_t i = 0 ; i < 4 ; i++) {
        fdcRegStatus0_s st0;
        uint8_t pcn = 0;

        FdcSendByte(FDC_CMD_SENSE_INTERRUPT);

        result = FdcGetByte((uint8_t *)&st0);

        /* The top 2 bits are set after a reset procedure.
        Either bit being set at any other time is an error indication. */
        (void) FdcCheckSt0(st0);

        result |= FdcGetByte(&pcn);

        if (result) {
            return STATUS_FAILURE;
        }
    }

    if (FdcConfigure() || FdcSpecify()) {
        return STATUS_FAILURE;
    }

    print_string("FDC INIT SUCCESS\n");
    return STATUS_SUCCESS;
}

status_e FdcSeek (uint16_t lba) {
    fdcRegStatus0_s st0;
    uint8_t pcn = 0, result = 0;

    /* Enable Motor and Drive */
    OutByte(FDC_ADDR_DIGITAL_OUT, 0x1C);

    /* Wait for the motor to get up to speed */
    for (volatile uint32_t i = 0 ; i < 25000000 ; i++) {
        IoWait();
    }

    /* Translate the lba address to a chs address */
    uint8_t cyl = 0, head = 0, sector = 0;
    ConvertLbaChs(lba, &cyl, &head, &sector);

    FdcSendByte(FDC_CMD_SEEK);

    /* (head number << 2) | (drive number) */
    FdcSendByte((head << 2) | (0));
    FdcSendByte(cyl);

    FdcWaitForRQM();

    FdcSendByte(FDC_CMD_SENSE_INTERRUPT);

    result = FdcGetByte((uint8_t *)&st0);

    result |= FdcCheckSt0(st0);

    result |= FdcGetByte(&pcn);

    if (result) {
        print_string("Seek failure.\n");
        return STATUS_FAILURE;
    }

    return STATUS_SUCCESS;
}

status_e FdcRecalibrate (void) {
    fdcRegStatus0_s st0;
    uint8_t pcn = 0, result = 0;

    /* Enable Motor and Drive */
    OutByte(FDC_ADDR_DIGITAL_OUT, 0x1C);

    /* Wait for the motor to get up to speed */
    for (uint32_t i = 0 ; i < 25000000 ; i++) {
        IoWait();
    }

    FdcSendByte(FDC_CMD_RECALIBRATE);
    FdcSendByte(0);                   /* Drive number */

    FdcWaitForRQM();

    FdcSendByte(FDC_CMD_SENSE_INTERRUPT);

    result = FdcGetByte((uint8_t *)&st0);
    result |= FdcCheckSt0(st0);
    result |= FdcGetByte(&pcn);

    if (result) {
        print_string("Seek failure.\n");
        return STATUS_FAILURE;
    }

    return STATUS_SUCCESS;
}

/* TODO: Add further status checks */
status_e FdcRead(const uint16_t lba, uint8_t *buffer) {
    (void)buffer;

    for (uint8_t retries = 0 ; retries < 3 ; retries++) {
        print_string("1\n");
        if (FdcSeek(lba) == STATUS_FAILURE || FdcRecalibrate() == STATUS_FAILURE) {
            continue;
        }

        /* Head settling time */
        for (uint16_t i = 0 ; i < (MAX_UINT16 - 1) ; i++) {
            IoWait();
        }
        print_string("2\n");
        if (FdcSendCmdReadData(lba)) {
            print_string("send cmd failed");
            return STATUS_FAILURE;
        }

        print_string("3\n");
        uint8_t local[512] = {0};

        for (uint16_t i = 0 ; i < 512 ; i++) {
            FdcGetByte(&local[i]);
            print_hex(local[i]);
        }

        print_string("Sucessfull end of FdcRead.\n");

        return STATUS_SUCCESS;
    }
    print_string("\nFAILURE FDC READ\n");

    return STATUS_FAILURE;
}

status_e FdcWrite(const uint16_t lba, uint8_t *buffer) {
    (void)lba;
    (void)buffer;
    return STATUS_SUCCESS;
}

status_e FdcSpecify(void) {
    uint8_t result = 0;

    result = FdcSendByte(FDC_CMD_SPECIFY);
    /* (SRT_value << 4) | (HUT_value)  */
    result |= FdcSendByte((8 << 4) | (0));   /* SRT = 8ms, HUT = Maximum */
    /* (HLT_value << 1) | (NDMA) */
    result |= FdcSendByte((5 << 1) | (1));   /* HLT = 5ms, NDMA = No */

    if (result) {
        return STATUS_FAILURE;
    }
    return STATUS_SUCCESS;
}

status_e FdcConfigure(void) {
    uint8_t result = 0;

    result = FdcSendByte(FDC_CMD_CONFIGURE);
    result |= FdcSendByte(0x0);
    /* (implied seek enable << 6) | (fifo disable << 5) | (polling disable << 4) | (threshold value) */
    result |= FdcSendByte((1 << 6) | (0 << 5) | (0 << 4) | (8));
    /* Set precompensation value to default */
    result |= FdcSendByte(0x0);

    if (result){
        return STATUS_FAILURE;
    }

    return STATUS_SUCCESS;
}

void FdcReset(void) {
    /* Disable the FDC */
    OutByte(FDC_ADDR_DIGITAL_OUT, 0x00);

    /* Wait */
    for(uint16_t i = 0 ; i < (MAX_UINT16 - 1) ; i++) {
        IoWait();
    }

    /* Enable the FDC */
    OutByte(FDC_ADDR_DIGITAL_OUT, 0x0C);

    /* Wait */
    for(uint16_t i = 0 ; i < (MAX_UINT16 - 1) ; i++) {
        IoWait();
    }
}

void FdcWaitForRQM(void) {
    /* Check for RQM bit */
    while (InByte(FDC_ADDR_MAIN_STATUS) != (BIT(7))) {
        ; /* Polling loop, wait until the FDC is ready */
    }
}

status_e FdcSendByte(uint8_t byte) {
    uint32_t timeout = 0;

    /* Check for DIO and RQM bits - 10 XXX XXX */
    while ((InByte(FDC_ADDR_MAIN_STATUS) & (FDC_DIO_RQM_MASK)) != FDC_SEND_BYTE_VALUE) {
        timeout++;
        if (timeout >= 1000000) { /* TODO: Figure out a more reasonable number */
            print_string("Timeout error in FdcSendByte.\n");
            return STATUS_FAILURE;
        }
    }
    OutByte(FDC_ADDR_DATA_FIFO, byte);

    return STATUS_SUCCESS;
}

status_e FdcGetByte(uint8_t *const byte) {
    uint32_t timeout = 0;
    /* Check for DIO and RQM bits - 11 XXX XXX*/
    while ((InByte(FDC_ADDR_MAIN_STATUS) & (FDC_DIO_RQM_MASK)) != FDC_GET_BYTE_VALUE) {
        timeout++;
        if (timeout >= 1000000) { /* TODO: Figure out a more reasonable number */
            print_string("Timeout error in FdcGetByte.\n");
            return STATUS_FAILURE;
        }
    }
    *byte = InByte(FDC_ADDR_DATA_FIFO);

    return STATUS_SUCCESS;
}
/* WIP */
// static status_e FdcSendCommand(const fdcCommands_e fdcCmd, uint32_t result, ...) {
//     if (FdcSendByte(fdcCmd) == STATUS_FAILURE) {
//         return STATUS_FAILURE;
//     }

//     switch (fdcCmd) {
//     case FDC_CMD_READ_TRACK:
//     case FDC_CMD_SPECIFY:
//     case FDC_CMD_SENSE_DRIVE_STATUS:
//     case FDC_CMD_WRITE_DATA:
//     case FDC_CMD_READ_DATA:
//     case FDC_CMD_RECALIBRATE:
//     case FDC_CMD_SENSE_INTERRUPT:
//     case FDC_CMD_WRITE_DELETED_DATA:
//     case FDC_CMD_READ_ID:
//     case FDC_CMD_READ_DELETED_DATA:
//     case FDC_CMD_FORMAT_TRACK:
//     case FDC_CMD_DUMPREG:
//     case FDC_CMD_SEEK:
//     case FDC_CMD_VERSION:
//     case FDC_CMD_SCAN_EQUAL:
//     case FDC_CMD_PERPENDICULAR_MODE:
//     case FDC_CMD_CONFIGURE:
//     case FDC_CMD_LOCK:
//     case FDC_CMD_VERIFY:
//     case FDC_CMD_SCAN_LOW_OR_EQUAL:
//     case FDC_CMD_SCAN_HIGH_OR_EQUAL:
//         break;
//     default:
//         return STATUS_FAILURE;
//     }

//     return STATUS_FAILURE;
// }



// if (in command phase)
// send command
// if (command not valid)
//     - If it was invalid, the next time the RQM bit in
//     the MSR register is a ‘‘1’’ the DIO and CB bits will
//     also be ‘‘1’’, indicating the FIFO must be read
//     - A result byte of 80H will be read out of the FIFO, indi-
//     cating an invalid command was issued.
//     - After reading
//     the result byte from the FIFO the 82077AA will re-
//     turn to the command phase.



status_e FdcSendCmdReadData(uint8_t lba) {
    FdcSendByte(FDC_CMD_READ_DATA);

    /* Check if the command was valid */
    {
        FdcPrintRegs();
        uint8_t status = 0;
        FdcWaitForRQM();
        print_string("2.1\n");

        if ((InByte(FDC_ADDR_MAIN_STATUS) & FDC_DIO_CMDB_MASK) == FDC_DIO_CMDB_MASK) {
            FdcGetByte(&status);
        }

        if (status == 0x80) {
            return STATUS_FAILURE;
        }
    }

    uint8_t result = 0, cylinder = 0, head = 0, sector = 0, sectorSize = 2;
    fdcRegStatus0_s st0; /* Status Register 0*/
    fdcRegStatus1_s st1; /* Status Register 1*/
    fdcRegStatus2_s st2; /* Status Register 2*/

    ConvertLbaChs(lba, &cylinder, &head, &sector);
    print_string("2.2\n");

    result |= FdcSendByte(cylinder);
    result |= FdcSendByte(head);
    result |= FdcSendByte(sector);
    result |= FdcSendByte(sectorSize); /* Sector size of 512 bytes (128 * X^2) */
    result |= FdcSendByte(18);         /* EOT */
    result |= FdcSendByte(0x1B);       /* GPL */
    result |= FdcSendByte(0xFF);       /* DTL */

    if (result) {
        return STATUS_FAILURE;
    }
    print_string("2.3\n");

    FdcGetByte((uint8_t *)&st0);
    FdcGetByte((uint8_t *)&st1);
    FdcGetByte((uint8_t *)&st2);

    result |= FdcCheckSt0(st0);
    result |= FdcCheckSt1(st1);
    result |= FdcCheckSt2(st2);

    FdcGetByte(&cylinder);
    FdcGetByte(&head);
    FdcGetByte(&sector);
    FdcGetByte(&sectorSize);

    return STATUS_SUCCESS;
}


status_e FdcCheckSt0(const fdcRegStatus0_s st0) {
    status_e result = STATUS_SUCCESS;
    (void)st0;
    // k_print("Drive Select =    %d.\n", st0->ds);
    // k_print("Head Address =    %d.\n", st0->h);
    // k_print("Equipment Check = %d.\n", st0->ec);
    // k_print("Seek End =        %d.\n", st0->se);
    // k_print("Interrupt Code =  %d.\n", st0->ic);

    return result;
}

status_e FdcCheckSt1(const fdcRegStatus1_s st1) {
    status_e result = STATUS_SUCCESS;
    (void)st1;
    // k_print("Missing Address Mark = %d.\n", st1->ma);
    // k_print("Not Writable =         %d.\n", st1->nw);
    // k_print("No Data =              %d.\n", st1->nd);
    // k_print("Overrun/Underrun =     %d.\n", st1->or);
    // k_print("Data Error =           %d.\n", st1->de);
    // k_print("End of Cylinder =      %d.\n", st1->en);

    return result;
}

status_e FdcCheckSt2(const fdcRegStatus2_s st2) {
    status_e result = STATUS_SUCCESS;
    (void)st2;
    // k_print("Missing Data Address Mark = %d.\n", st2->md);
    // k_print("Bad Cylinder =              %d.\n", st2->bc);
    // k_print("Wrong Cylinder =            %d.\n", st2->wc);
    // k_print("Data Error in Data Field =  %d.\n", st2->dd);
    // k_print("Control Mark =              %d.\n", st2->cm);

    return result;
}

status_e FdcCheckSt3(const fdcRegStatus3_s st3) {
    status_e result = STATUS_SUCCESS;
    (void)st3;
    // k_print("Drive Select =    %d.\n", st3->ds);
    // k_print("Head Address =    %d.\n", st3->hd);
    // k_print("Track 0 =         %d.\n", st3->t0);
    // k_print("Write Protected = %d.\n", st3->wp);

    return result;
}

