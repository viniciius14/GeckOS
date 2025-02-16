
FAT 12 -> 1.44 MB
FAT 16 -> 128 MB -> 262144 sectors {262144, 4}, /* disks up to 128 MB, 2k cluster */
FAT 32 -> 512 MB -> 1048576 sectors {16777216, 8}, /* disks up to 8 GB, 4k cluster */

BPB_SecPerClus (4 & 8)

for i == 0 we got BPB_FATSz16: 0 and BPB_FATSz32 0

for i == 1 we got BPB_FATSz16: 1 and BPB_FATSz32 0

for i == 2 we got BPB_FATSz16: 0 and BPB_FATSz32 4

1 MB =  1048576 bytes