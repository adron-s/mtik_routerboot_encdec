#!/bin/bash

ROUTERBOOT_OFFSET=0xb0000

tobi() {
	printf "0: %.8x" $1 | sed -E 's/0: (..)(..)(..)(..)/0: \4\3\2\1/' | xxd -r -g0
}
crc32() {
	echo $((0x$(rhash -C ${1}  | sed 's/[^ ]* //' | tail -n 1)))
}
fsize() {
	du -b $1 | sed 's/[^0-9].*//g'
}
read_uint() {
	local SIZE
	SIZE=$(xxd -p -l 4 -s $(($2)) $1 | sed -E 's/(..)(..)(..)(..)/\4\3\2\1/')
	echo $((0x$SIZE))
}

[ "${BASH}" = "/bin/bash" ] || {
	echo "Please use only /bin/bash for this script !!!"
	exit 1
}