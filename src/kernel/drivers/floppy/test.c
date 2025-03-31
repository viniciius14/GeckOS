void my_test_func() {
    volatile unsigned short *VGA = (volatile unsigned short*)0xB8000;
    VGA[12*80+40] = (0x0F << 8) | 'A';

    while (1) {}
}
