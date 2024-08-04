
void _kernel_main(void) {
    unsigned char * mem = (unsigned char *)0xB8000;
    mem[0] = 'B';

    for (;;){}
}