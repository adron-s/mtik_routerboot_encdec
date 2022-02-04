#!/bin/sh

BACKUP_RBT_OFFSET=$((0x95c04))
dd if=./bins/mtdblock2.bin of=./bins/backup-rbt.enc bs=1 skip=${BACKUP_RBT_OFFSET} count=$((0xaf000-BACKUP_RBT_OFFSET))
./nrv2b/nrv2b d ./bins/backup-rbt.enc ./bins/backup-rbt.dec
