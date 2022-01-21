#!/bin/bash

#Only for Mikrotik RB5009 and RouterBOOT-7.2rc1 !
#On other devices, offsets and bit order may be different!

. ./func.sh

./get_from_mtd.sh

#fix the UART - decoded RouterBOOT binary patching
TARGET=./bins/rbt-7.2rc1-MTD.dec
printf "\x20\x00\x80\x52\x20\x0c\x01\xb9\xc0\x03\x5f\xd6" | dd of=$TARGET bs=1 seek=$((0x0144)) count=16 conv=notrunc
printf "\x1f\x20\x03\xd5" | dd of=$TARGET bs=1 seek=$((0xB348)) count=4 conv=notrunc

#pack it back to mtdblock2-OWL.bin
./pack_to_fwf.sh && ./pack_to_mtd.sh $1

#soft/hard-config patching
TARGET=./bins/mtdblock2-OWL.bin

exit 0

#boot-device - soft-config(0x93)
#val=00 #0 - boot over Ethernet, 01 - nand-if-fail-then-ethernet, 03 - try-ethernet-once-than-nand, ...
#printf "\x${val}\x00\x00\x00" | dd of=$TARGET bs=1 seek=$((0xc0024)) count=4 conv=notrunc

#UART speed - soft-config(0x01)
val=00 #0 - 115200
printf "\x${val}\x00\x00\x00" | dd of=$TARGET bs=1 seek=$((0xc0014)) count=4 conv=notrunc

#NO_UART bit - hard-config->RB_HW_OPTIONS(0x15), BIT(0)
val=04 #unset BIT(0): 5->4
printf "\x${val}\x00\x18\x00" | dd of=$TARGET bs=1 seek=$((0xaf04c)) count=4 conv=notrunc
