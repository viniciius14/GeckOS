#include "fdc.h"

/* TEMP DELETE LATER */

uint16_t *mem = (uint16_t *)0xB8000;

static uint8_t cursor_x = 0;
static uint8_t cursor_y = 0;

void screen_clear(void){
    memset(mem, 0, 10000);
}
void print_string(char * arr) {
    uint32_t i = 0;
    while(arr[i]) {
        print_char(arr[i++]);
    }
}

void print_char(char letter) {
    if(letter == '\n'){
        cursor_y++;
        cursor_x = 0;
        if (cursor_y > 25){
            screen_clear();
            cursor_y = 0;
        }
    }
    else{
        uint8_t  attributeByte = (0 << 4) | (0x0F & 0x0F);

        uint16_t *location = mem + (cursor_y * 80 + cursor_x);
        *location = letter | (attributeByte << 8);
        cursor_x++;
    }
}
/* TEMP DELETE LATER */

uint8_t fdc_init(void) {
    uint8_t res = 0;

    fdc_reset();

    /* Set datarate to 500Kbps */
    outbyte(FDC_DATA_RATE_SEL, 0x0);

    fdc_wait_for_interrupt();

    /* 4 SENSE INTERRUPT STATUS commands need to be issued to clear the status flags for each drive.*/
    for (uint8_t i = 0 ; i != 4 ; i++) {
        uint8_t st0 = 0, pcn = 0;

        fdc_send_byte(FDC_CMD_SENSE_INTERRUPT);

        res = fdc_get_byte(&st0);

        /* The top 2 bits are set after a reset procedure.
        Either bit being set at any other time is an error indication. */
        (void)check_st0(st0);

        res |= fdc_get_byte(&pcn);

        if (res) {
            return 1;
        }
    }

    if (fdc_configure()) {
        return 1;
    }

    if (fdc_specify()) {
        return 1;
    }

    return res;
}

uint8_t fdc_seek (uint16_t lba) {
    uint8_t st0 = 0, pcn = 0, res = 0;

    /* Enable Motor and Drive */
    outbyte(FDC_DIGITAL_OUT, 0x1C);

    /* Wait for the motor to get up to speed */
    for (volatile uint32_t i = 0 ; i != 25000000 ; i++) {
        io_wait();
    }

    /* Translate the lba address to a chs address */
    uint8_t cyl = 0, head = 0, sector = 0;
    lba_2_chs(lba, &cyl, &head, &sector);

    fdc_send_byte(FDC_CMD_SEEK);

    /* (head number << 2) | (drive number) */
    fdc_send_byte((head << 2) | (0));
    fdc_send_byte(cyl);

    fdc_wait_for_interrupt();

    fdc_send_byte(FDC_CMD_SENSE_INTERRUPT);

    res = fdc_get_byte(&st0);

    res |= check_st0(st0);

    res |= fdc_get_byte(&pcn);

    if(res) {
        print_string("Seek failure.\n");
        return 1;
    }

    return 0;
}

uint8_t fdc_recalibrate (void) {
    uint8_t st0 = 0, pcn = 0, res = 0;

    /* Enable Motor and Drive */
    outbyte(FDC_DIGITAL_OUT, 0x1C);

    /* Wait for the motor to get up to speed */
    for (volatile uint32_t i = 0 ; i != 25000000 ; i++) {
        io_wait();
    }

    fdc_send_byte(FDC_CMD_RECALIBRATE);
    fdc_send_byte(0);                   /* Drive number */

    fdc_wait_for_interrupt();

    fdc_send_byte(FDC_CMD_SENSE_INTERRUPT);

    res = fdc_get_byte(&st0);
    res |= check_st0(st0);
    res |= fdc_get_byte(&pcn);

    if(res) {
        print_string("Seek failure.\n");
        return 1;
    }

    return 0;
}

/* TBD: Add further status checks */
uint8_t fdc_read(uint16_t lba, uint8_t *buffer) {
    print_string("fdc_read called.\n");
    for (uint8_t retries = 0 ; retries != 3 ; retries++) {
        uint8_t st0 = 0, st1 = 0, st2 = 0, bps = 2, res = 0, cyl = 0, head = 0, sector = 0;

        res = fdc_recalibrate();

        lba_2_chs(lba, &cyl, &head, &sector);

        if (fdc_seek(lba)) {
            print_string("Could not seek the sector.\n");
            continue;
        }

        /* Head settling time */
        for (uint16_t i = 0 ; i != 1500 ; i++) {
            io_wait();
        }

        res |= fdc_send_byte(FDC_CMD_READ_DATA);

        /* (head number << 2) | (drive number) */
        res |= fdc_send_byte(((head << 2) | (0)));
        res |= fdc_send_byte(cyl);
        res |= fdc_send_byte(head);
        res |= fdc_send_byte(sector);
        res |= fdc_send_byte(bps);     /* Sector size of 512 bytes (128 * X^2) */
        res |= fdc_send_byte(18);      /* The last sector of the current track */
        res |= fdc_send_byte(0x1B);    /* GAP1 default size*/
        res |= fdc_send_byte(0xFF);    /* Special sector size */

        if (res) {
            print_string("Error while attempting read command.\n");
            continue;
        }

        fdc_wait_for_interrupt(); // <--- Issue here, it seems to never leave from this call

        res |= fdc_get_byte(&st0);
        res |= fdc_get_byte(&st1);
        res |= fdc_get_byte(&st2);
        res |= fdc_get_byte(&cyl);
        res |= fdc_get_byte(&head);
        res |= fdc_get_byte(&sector);
        res |= fdc_get_byte(&bps);
        if (res) {
            print_string("Error while getting response from read command.\n");
            continue;
        }

        res |= check_st0(st0);
        res |= check_st1(st1);
        res |= check_st2(st2);

        if (res) {
            print_string("Status did not pass.\n");
            continue;
        }

        for (uint16_t i = 0 ; i != 512 ; i++) {
            fdc_get_byte(&buffer[i]);
        }

        print_string("sucessfull end of fdc_read.\n");

        return 0;
    }

    return 1;
}

uint8_t fdc_write(uint16_t lba, uint8_t *buffer) {
    (void)lba;
    (void)buffer;
    return 0;
}

uint8_t fdc_specify (void) {
    uint8_t res = 0;

    res = fdc_send_byte(FDC_CMD_SPECIFY);
    /* (SRT_value << 4) | (HUT_value)  */
    res |= fdc_send_byte((8 << 4) | (0));   /* SRT = 8ms, HUT = Maximum */
    /* (HLT_value << 1) | (NDMA) */
    res |= fdc_send_byte((5 << 1) | (1));   /* HLT = 5ms, NDMA = No */

    return res;
}

uint8_t fdc_configure (void) {
    uint8_t res = 0;

    res = fdc_send_byte(FDC_CMD_CONFIGURE);
    res |= fdc_send_byte(0x0);
    /* (implied seek enable << 6) | (fifo disable << 5) | (polling disable << 4) | (threshold value) */
    res |= fdc_send_byte((1 << 6) | (0 << 5) | (0 << 4) | (8));
    /* Set precompensation value to default */
    res |= fdc_send_byte(0x0);

    return res;
}

void fdc_reset(void) {
    outbyte(FDC_DIGITAL_OUT, 0x00);    /* Disable the FDC */

    for(uint8_t i = 0 ; i != 50 ; i++) {
        io_wait();                      /* Wait */
    }

    outbyte(FDC_DIGITAL_OUT, 0x0C);    /* Enable the FDC */

    for(uint8_t i = 0 ; i != 50 ; i++) {
        io_wait();                      /* Wait */
    }
}

void fdc_wait_for_interrupt(void) {
    while ((inbyte(FDC_MAIN_STATUS) >> 6) != 2) {
        /* Polling loop, wait until the FDC is ready */
    }
}

uint8_t fdc_send_byte(uint8_t byte) {
    uint32_t timeout = 0;

    while ((inbyte(FDC_MAIN_STATUS)) >> 6 != 2) {
        timeout++;
        if (timeout == 1000000) { /* TBD: Figure out a more resonable number */
            print_string("Timeout error in fdc_send_byte.\n");
            return 1;
        }
    }
    outbyte(FDC_DATA_FIFO, byte);

    return 0;
}

uint8_t fdc_get_byte(uint8_t *byte) {
    uint32_t timeout = 0;

    while ((inbyte(FDC_MAIN_STATUS)) >> 6 != 3) {
        timeout++;
        if (timeout == 1000000) { /* TBD: Figure out a more resonable number */
            print_string("Timeout error in fdc_get_byte.\n");
            return 1;
        }
    }
    *byte = inbyte(FDC_DATA_FIFO);

    return 0;
}

uint8_t check_st0(uint8_t st0) {
    switch((st0 & 0x3)){
        case 0:
            print_string("Drive 0 selected.\n");
            goto switch_2;
        case 1:
            print_string("Drive 1 selected.\n");
            goto switch_2;
        case 2:
            print_string("Drive 2 selected.\n");
            goto switch_2;
        case 3:
            print_string("Drive 3 selected.\n");
    }

switch_2:
    if (!(st0 & 0x4)) {
        print_string("H (Head Address) is 0.\n");
    }
    if (st0 & 0x10) {
        print_string("EC (Equipment Check) is 1.\n");
    }
    if (st0 & 0x20) {
        print_string("SE (Seek End) is 1.\n");
    }

    switch(((st0) >> 6)){
        case 0:
            print_string("Normal termination of command.\n");
            return 0;
        case 1:
            print_string("Abnormal termination of command.\n");
            return 1;
        case 2:
            print_string("Invalid command.\n");
            return 1;
        case 3:
            print_string("Abnormal termination caused by Polling.\n");
            return 1;
    }
    return 1;
}

uint8_t check_st1(uint8_t st1) {
    if (st1 & 0x1) {
        print_string("Missing Addres Mark.\n");
        return 1;
    }
    if (st1 & 0x2) {
        print_string("Not Writable.\n");
        return 1;
    }
    if (st1 & 0x4) {
        print_string("No Data.\n");
        return 1;
    }
    if (st1 & 0x10) {
        print_string("Overrun/Underrun.\n");
        return 1;
    }
    if (st1 & 0x20) {
        print_string("Data Error.\n");
        return 1;
    }
    if (st1 & 0x80) {
        print_string("End of Cylinder.\n");
        return 1;
    }

    return 0;
}

uint8_t check_st2(uint8_t st2) {
    if (st2 & 0x1) {
        print_string("Missing Data Address Mark.\n");
        return 1;
    }
    if (st2 & 0x2) {
        print_string("Bad Cylinder.\n");
        return 1;
    }
    if (st2 & 0x10) {
        print_string("Wrong Cylinder.\n");
        return 1;
    }
    if (st2 & 0x20) {
        print_string("Data Error in Data Field.\n");
        return 1;
    }
    if (st2 & 0x40) {
        print_string("Control Mark.\n");
        return 1;
    }

    return 0;
}

/* TBD DELETE THIS */
uint8_t check_st3(uint8_t st3) {
    if ((st3 & 0x3) == 0) {
        print_string("Drive 0 selected.\n");
    } else {
        print_string("Wrong drive selected.\n");
        return 1;
    }
    if (st3 & 0x4) {
        print_string("Head Address is 1.\n");
    } else {
        print_string("Head Address is 0.\n");
    }

    if (st3 & 0x8) {
        print_string("Track bit is 1.\n");
    } else {
        print_string("Track bit is 0.\n");
    }
    if (st3 & 0x20) {
        print_string("Write protected.\n");
        return 1;
    }

    return 0;
}
