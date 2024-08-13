
void _kernel_main(void) {
    volatile unsigned char * mem = (unsigned char *)0xB8000;
    mem[0] = 'B';
    volatile char* a = "This is my string";
    mem[4] = a[0];

    for (;;){}
}