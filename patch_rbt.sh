#!/bin/sh

#Only for Mikrotik RB5009 and RouterBOOT-7.2rc1 !
#On other devices, offsets and bit order may be different!

. ./func.sh

#./get_from_mtd.sh

TARGET=${2:-./bins/rbt-7.2rc1-MTD.dec}

#RouterBOOT patches

#fix the UART
binay_patch 0x0144 "20 00 80 52  20 0c 01 b9  c0 03 5f d6"
binay_patch 0xB348 "1f 20 03 d5"

#pack it back to mtdblock2-OWL.bin
./pack_to_fwf.sh && ./pack_to_mtd.sh $1

exit 0

#soft-config && hard-config patches
TARGET=./bins/mtdblock2-OWL.bin

#boot-device - soft-config(0x93)
#val=00 #0 - boot over Ethernet, 01 - nand-if-fail-then-ethernet, 03 - try-ethernet-once-than-nand, ...
#binay_patch 0xc0024 "${val} 00 00 00"

#UART speed - soft-config(0x01)
val=00 #0 - 115200
binay_patch 0xc0014 "${val} 00 00 00"

#NO_UART bit - hard-config->RB_HW_OPTIONS(0x15), BIT(0)
val=04 #unset BIT(0): 5->4
binay_patch 0xaf04c "${val} 00 18 00"
