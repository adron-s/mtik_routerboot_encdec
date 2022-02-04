#!/bin/sh

#for pack decoded(ARMv8 bytecode) RouterBOOT to its
#original format - fwf (header + UCL NRV2B + CRC32)

. ./func.sh

rm -Rf ./bins/tmp
mkdir ./bins/tmp

#TARGET=./bins/routerboot-7.2rc1.dec
TARGET=${1:-./bins/rbt-7.2rc1-MTD.dec}
#RESULT=./bins/res-7.2rc1-MODI.fwf
RESULT=./bins/res-7.2rc1-MTD.bin

HEAD=./bins/head.enc
ENC_TMP=./bins/tmp/rbt-MODI.enc

echo "TARGET is ${TARGET}"
echo ""

rm -f $RESULT
[ -f $HEAD ] && cat $HEAD > $RESULT
./nrv2b/nrv2b e $TARGET $ENC_TMP || exit 1
SIZE=$(fsize $ENC_TMP)
SIZE_ALI=$((SIZE/4*4))
SIZE_DELTA=0
[ $SIZE -ne $SIZE_ALI ] && {
	SIZE_ALI=$((SIZE_ALI+4))
	SIZE_DELTA=$((SIZE_ALI-SIZE))
	echo "Doing alignment: $SIZE -> $SIZE_ALI, delta: $SIZE_DELTA"
	cat ${ENC_TMP} > ${ENC_TMP}.2
	dd if=/dev/zero bs=$SIZE_DELTA count=1 >> ${ENC_TMP}.2
	cat ${ENC_TMP}.2 > ${ENC_TMP}
	rm ${ENC_TMP}.2
	SIZE=$SIZE_ALI
}
SIZE=$((SIZE+4)) #4 byte for CRC32 in tail
tobi $SIZE > ${ENC_TMP}.2
cat ${ENC_TMP} >> ${ENC_TMP}.2
cat ${ENC_TMP}.2 >> $RESULT
CRC32=$(crc32 ${ENC_TMP}.2)
rm ${ENC_TMP}.2
#rm ${ENC_TMP}
tobi $CRC32 >> $RESULT

#for check: md5sum ./bins/$RESULT ./bins/70x0-7.2rc1.fwf
#echo ""
#echo "The result file is $RESULT"
#echo ""
