# BuildSystem

## MAKE will have the following user acessible targets:

### GeckOS
    - will produce the .img/.bin/.elf output file
    - split into subproject and dirs
    - Each subproject is responsible for linking/creating a shared library/ static library of the files it and it's subdirectorys contain
    - Each dir is responsible for compiling the files it contains



SCRATCH THAT

SUB PROJECTs will be orchestrators that just call shit while dirs will compile stuff the main makefile at the end will compile all .o files

#### Execution order
    1. Get prerequisites
        - Check the bootloader flag and see which one to include
        - Propagate the appropriate flags
    2. Obtain the includes
        - either get all file names in the project








### test
    - will run a battery of tests in tests/ to evaluate the functionalitys implemented

### debug
    - will build the output file with the -save-temps flag to get the output of the compiled code
    - will build the output file with the DEBUG flag defined
    - will build the output file with the -save-temps flag to get the output of the compiled code for the debug version of the code

### run
    - Will run ALL images in the build directory

### clean
    - will clean all intermediary files




# GeckOs file system structure
src/
    kernel/
        tasking/    # Processes and threads
        memory/     #
    drivers/
        floppy/
        hdd/
        video or vga or whatever/
        ethernet/
        usb/
        uart/
        peripherals/    # stuff that can be attached and removed easily?
            keyboard/
            mouse/
    fileSystem/
        fat/
        ext/
    libraries/
        dataStructures/
        utils/
        math/
    applications/   # default kernel level "apps" like guis, managers
        coreApp1/
        coreApp2/
        coreApp3/
    user/           # user apps like note pad, music player
        interfaces/
        app1/
        app2/
        app3/
bootloader/
    GBL/
    limine/
    GRUB/

kernel/
├── arch/
│   └── x86/
│       └── drivers/      <-- x86 dependent driver
│           └── input
│              └── ps2.c
│              └── COM1/COM2 (mouse)
│
├── drivers/              <-- (Generic or cross-platform drivers)
│   ├── input/
│   │   ├── keyboard.c    <-- Generic keyboard logic (interprets scancodes to ASCII)
│   └── usb/ uart/ ...
│       └── ...
