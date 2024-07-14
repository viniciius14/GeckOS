dd if=/dev/zero of=bin/geckos.img bs=512 count=2880
mkfs.fat -F 12 -n "GECKOS" bin/geckos.img

hexdump bin/geckos.img

0000000 3ceb 6d90 666b 2e73 6166 0074 0102 0001
0000010 e002 4000 f00b 0009 0012 0002 0000 0000
0000020 0000 0000 0000 4b29 8580 47a0 4345 4f4b
0000030 2053 2020 2020 4146 3154 2032 2020 1f0e
0000040 5bbe ac7c c022 0b74 b456 bb0e 0007 10cd
0000050 eb5e 32f0 cde4 cd16 eb19 54fe 6968 2073
0000060 7369 6e20 746f 6120 6220 6f6f 6174 6c62     Boot Sector
0000070 2065 6964 6b73 202e 5020 656c 7361 2065
0000080 6e69 6573 7472 6120 6220 6f6f 6174 6c62
0000090 2065 6c66 706f 7970 6120 646e 0a0d 7270
00000a0 7365 2073 6e61 2079 656b 2079 6f74 7420
00000b0 7972 6120 6167 6e69 2e20 2e2e 0d20 000a
00000c0 0000 0000 0000 0000 0000 0000 0000 0000
*
00001f0 0000 0000 0000 0000 0000 0000 0000 aa55
0000200 fff0 00ff 0000 0000 0000 0000 0000 0000
0000210 0000 0000 0000 0000 0000 0000 0000 0000
*                                                   File Allocation Tables
0001390 0000 0000 0000 0000 0000 0000 0000 0000
0001400 fff0 00ff 0000 0000 0000 0000 0000 0000
0001410 0000 0000 0000 0000 0000 0000 0000 0000
*
0002600 4547 4b43 534f 2020 2020 0820 0000 a762
0002610 5891 5891 0000 a762 5891 0000 0000 0000     Data
0002620 0000 0000 0000 0000 0000 0000 0000 0000
*
0168000

nasm -f bin src/filesystem/FAT/12/boot_sector.S -o bin/boot_sector.bin
dd if=bin/boot_sector.bin of=bin/geckos.img conv=notrunc
hexdump bin/geckos.img

0000000 3ceb 4d90 5753 4e49 2e34 0031 0102 0001
0000010 e002 4000 f00b 0009 0012 0002 0000 0000
0000020 0000 0000 0000 1229 5634 6778 6365 4f6b
0000030 2053 2020 2020 4146 3154 2032 2020 c031
0000040 d88e c08e d08e 00bc 067c 4e68 cb7c 1688
0000050 7c24 b406 cd08 b413 b00e cd44 0710 e180
0000060 303f 89ed 180e fe7c 88c6 1a36 a17c 7c16
0000070 1e8a 7c10 ff30 e3f7 0603 7c0e 16a1 c17c
0000080 05e0 d231 36f7 7c0b d285 0174 8840 58c1
0000090 168a 7c24 00bb e87e 00af db31 00bf be7e
00000a0 7d5a 0bb9 5700 a6f3 745f 8310 20c7 3b43
00000b0 111e 7c7c b4ea b00e cd45 8b10 1a45 65a3
00000c0 a17d 7c0e 00bb 8a7e 160e 8a7c 2416 e87c
00000d0 0077 00bb 8e20 bbc3 2000 65a1 837d 1fc0
00000e0 01b1 168a 7c24 60e8 0300 0b1e a17c 7d65
00000f0 03b9 f700 b9e1 0002 f1f7 00be 017e 3ec6
0000100 048b d209 0574 e8c1 eb04 2503 0fff f83d
0000110 730f a305 7d65 c2eb 168a 7c24 00b8 8e20
0000120 8ed8 eac0 0000 2000 feeb 5250 d231 36f7
0000130 7c18 8942 31d1 f7d2 1a36 887c 88d6 c0c5
0000140 06e4 e108 8858 58c2 50c3 5153 5752 e851
0000150 ffd8 b458 bf02 0003 f4fa 454b 4e52 4c45
0000160 2020 4942 004e 0000 0000 0000 0000 0000
0000170 0000 0000 0000 0000 0000 0000 0000 0000
*
00001f0 0000 0000 0000 0000 0000 0000 0000 aa55
0000200 fff0 00ff 0000 0000 0000 0000 0000 0000
0000210 0000 0000 0000 0000 0000 0000 0000 0000
*
0001400 fff0 00ff 0000 0000 0000 0000 0000 0000
0001410 0000 0000 0000 0000 0000 0000 0000 0000
*
0002600 4547 4b43 534f 2020 2020 0820 0000 a762
0002610 5891 5891 0000 a762 5891 0000 0000 0000
0002620 0000 0000 0000 0000 0000 0000 0000 0000
*
0168000

mcopy -i bin/geckos.img bin/kernel.bin "::kernel.bin"
hexdump bin/geckos.img

0000000 3ceb 4d90 5753 4e49 2e34 0031 0102 0001
0000010 e002 4000 f00b 0009 0012 0002 0000 0000
0000020 0000 0000 0000 1229 5634 6778 6365 4f6b
0000030 2053 2020 2020 4146 3154 2032 2020 c031
0000040 d88e c08e d08e 00bc 067c 4e68 cb7c 1688
0000050 7c24 b406 cd08 b413 b00e cd44 0710 e180
0000060 303f 89ed 180e fe7c 88c6 1a36 a17c 7c16
0000070 1e8a 7c10 ff30 e3f7 0603 7c0e 16a1 c17c
0000080 05e0 d231 36f7 7c0b d285 0174 8840 58c1
0000090 168a 7c24 00bb e87e 00af db31 00bf be7e
00000a0 7d5a 0bb9 5700 a6f3 745f 8310 20c7 3b43
00000b0 111e 7c7c b4ea b00e cd45 8b10 1a45 65a3
00000c0 a17d 7c0e 00bb 8a7e 160e 8a7c 2416 e87c
00000d0 0077 00bb 8e20 bbc3 2000 65a1 837d 1fc0
00000e0 01b1 168a 7c24 60e8 0300 0b1e a17c 7d65
00000f0 03b9 f700 b9e1 0002 f1f7 00be 017e 3ec6
0000100 048b d209 0574 e8c1 eb04 2503 0fff f83d
0000110 730f a305 7d65 c2eb 168a 7c24 00b8 8e20
0000120 8ed8 eac0 0000 2000 feeb 5250 d231 36f7
0000130 7c18 8942 31d1 f7d2 1a36 887c 88d6 c0c5
0000140 06e4 e108 8858 58c2 50c3 5153 5752 e851
0000150 ffd8 b458 bf02 0003 f4fa 454b 4e52 4c45
0000160 2020 4942 004e 0000 0000 0000 0000 0000
0000170 0000 0000 0000 0000 0000 0000 0000 0000
*
00001f0 0000 0000 0000 0000 0000 0000 0000 aa55
0000200 fff0 ffff 000f 0000 0000 0000 0000 0000
0000210 0000 0000 0000 0000 0000 0000 0000 0000
*
0001400 fff0 ffff 000f 0000 0000 0000 0000 0000
0001410 0000 0000 0000 0000 0000 0000 0000 0000
*
0002600 4547 4b43 534f 2020 2020 0820 0000 a762
0002610 5891 5891 0000 a762 5891 0000 0000 0000
0002620 454b 4e52 4c45 2020 4942 204e 0018 b117
0002630 5891 5891 0000 b117 5891 0002 0037 0000
0002640 0000 0000 0000 0000 0000 0000 0000 0000
*
0004200 1cbe e800 0002 f4fa 5056 ac53 c008 0874
0004210 0eb4 00b7 10cd f3eb 585b c35e 6548 6c6c
0004220 206f 6f77 6c72 2064 7266 6d6f 4b20 5245
0004230 454e 214c 0a0d 0000 0000 0000 0000 0000
0004240 0000 0000 0000 0000 0000 0000 0000 0000
*
0168000

mcopy -i bin/geckos.img test.txt "::test.txt"
hexdump bin/geckos.img

0000000 3ceb 4d90 5753 4e49 2e34 0031 0102 0001
0000010 e002 4000 f00b 0009 0012 0002 0000 0000
0000020 0000 0000 0000 1229 5634 6778 6365 4f6b
0000030 2053 2020 2020 4146 3154 2032 2020 c031
0000040 d88e c08e d08e 00bc 067c 4e68 cb7c 1688
0000050 7c24 b406 cd08 b413 b00e cd44 0710 e180
0000060 303f 89ed 180e fe7c 88c6 1a36 a17c 7c16
0000070 1e8a 7c10 ff30 e3f7 0603 7c0e 16a1 c17c
0000080 05e0 d231 36f7 7c0b d285 0174 8840 58c1
0000090 168a 7c24 00bb e87e 00af db31 00bf be7e
00000a0 7d5a 0bb9 5700 a6f3 745f 8310 20c7 3b43
00000b0 111e 7c7c b4ea b00e cd45 8b10 1a45 65a3
00000c0 a17d 7c0e 00bb 8a7e 160e 8a7c 2416 e87c
00000d0 0077 00bb 8e20 bbc3 2000 65a1 837d 1fc0
00000e0 01b1 168a 7c24 60e8 0300 0b1e a17c 7d65
00000f0 03b9 f700 b9e1 0002 f1f7 00be 017e 3ec6
0000100 048b d209 0574 e8c1 eb04 2503 0fff f83d
0000110 730f a305 7d65 c2eb 168a 7c24 00b8 8e20
0000120 8ed8 eac0 0000 2000 feeb 5250 d231 36f7
0000130 7c18 8942 31d1 f7d2 1a36 887c 88d6 c0c5
0000140 06e4 e108 8858 58c2 50c3 5153 5752 e851
0000150 ffd8 b458 bf02 0003 f4fa 454b 4e52 4c45
0000160 2020 4942 004e 0000 0000 0000 0000 0000
0000170 0000 0000 0000 0000 0000 0000 0000 0000
*
00001f0 0000 0000 0000 0000 0000 0000 0000 aa55
0000200 fff0 ffff ffff 0000 0000 0000 0000 0000
0000210 0000 0000 0000 0000 0000 0000 0000 0000
*
0001400 fff0 ffff ffff 0000 0000 0000 0000 0000
0001410 0000 0000 0000 0000 0000 0000 0000 0000
*
0002600 4547 4b43 534f 2020 2020 0820 0000 a762
0002610 5891 5891 0000 a762 5891 0000 0000 0000
0002620 454b 4e52 4c45 2020 4942 204e 0018 b117
0002630 5891 5891 0000 b117 5891 0002 0037 0000
0002640 4554 5453 2020 2020 5854 2054 0018 b14c
0002650 5891 5891 0000 b14c 5891 0003 0007 0000
0002660 0000 0000 0000 0000 0000 0000 0000 0000
*
0004200 1cbe e800 0002 f4fa 5056 ac53 c008 0874
0004210 0eb4 00b7 10cd f3eb 585b c35e 6548 6c6c
0004220 206f 6f77 6c72 2064 7266 6d6f 4b20 5245
0004230 454e 214c 0a0d 0000 0000 0000 0000 0000
0004240 0000 0000 0000 0000 0000 0000 0000 0000
*
0004400 6f77 7a77 7265 0073 0000 0000 0000 0000
0004410 0000 0000 0000 0000 0000 0000 0000 0000
*
0168000