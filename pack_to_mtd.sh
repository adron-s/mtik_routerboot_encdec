#!/bin/sh

#for pack res-xxx-MODI.fwf back -> mtdblock2.bin

. ./func.sh

#TARGET=./bins/70x0-7.2rc1.fwf
#TARGET=./bins/res-7.2rc1-MTD.fwf
TARGET=./bins/res-7.2rc1-MTD.bin

SOURCE=./bins/mtdblock2.bin
RESULT=./bins/mtdblock2-OWL.bin

HEAD=./bins/tmp/mtd.head
BODY=./bins/tmp/rbt.bin
TAIL=./bins/tmp/mtd.tail

dd if=$SOURCE of=$HEAD bs=$((ROUTERBOOT_OFFSET)) count=1
SKIP=8
echo "$TARGET" | grep -q ".fwf" || SKIP=0 #if TARGET format is not *.fwf
dd if=$TARGET of=$BODY bs=4 skip=$SKIP
SIZE=$(fsize $BODY)
dd if=$SOURCE of=$TAIL bs=$((ROUTERBOOT_OFFSET+SIZE)) skip=1

cat $HEAD $BODY $TAIL > $RESULT

echo ""
echo "Now do the following on Your Mikrotik device:"
echo ""
echo "cd /flash/rw/disk/pub/static-bins/"
echo "nc 172.20.1.77 1111 | ./mtd write - RouterBoot"
echo ""
echo "sh /flash/rw/disk/pub/static-bins/lets-try.sh" | \
	xclip -selection clipboard
#echo "cat ${RESULT} | nc -l -p 1111 -q 1"
#echo ""

[ "$1" = "nc" ] && {
	echo "Ready for NC. port: 1111"
	cat ${RESULT} | nc -l -p 1111 -q 1
}
