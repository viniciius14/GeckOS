# GeckOs

# Dependencies

All that is needed to run this project is docker. Which can be started by running the script [docker_run.sh](/docker_run.sh).

# How to run

You can do ```make``` to compile the default image or ```make run``` to compile and run said image.

There is also the option to do a ```make all``` which will compile all the supported images.
Each of these supported images corresponds to a different filesystem and a specific hardware associated with that filesystem. Additionally, 32 bit and 64 bit versions of each image are also generated.

| Filesystem    |   Hardware    |
|:-------------:|:-------------:|
|    FAT 12     |  Floppy Disk  |
|    FAT 16     |      HDD      |
|    FAT 32     |      HDD      |

# Documentation

All the in depth documentation for this project can be found in the [docs](/docs/) folder.
