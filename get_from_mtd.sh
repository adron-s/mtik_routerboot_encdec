#!/bin/bash

#extract RouterBOOT from mtdblock2.bin and decode it from UCL NRV2B

. ./func.sh

mkdir -p ./bins

SOURCE=./bins/mtdblock2.bin
RESULT=./bins/rbt-7.2rc1-MTD.enc

SIZE=$(read_uint $SOURCE $ROUTERBOOT_OFFSET)
SIZE=$((SIZE-4)) #skip crc32 tail
echo ""
echo "RouterBOOT size is $SIZE + 4"
echo ""

dd if=$SOURCE of=$RESULT bs=1 skip=$((ROUTERBOOT_OFFSET+4)) count=$SIZE
SOURCE=$RESULT
RESULT=$(echo "$SOURCE" | sed 's/\.enc$/\.dec/')
./nrv2b/nrv2b d $SOURCE $RESULT

echo ""
echo "The result(binary) file is $RESULT"
echo ""
