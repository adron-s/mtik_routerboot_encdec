#!/bin/sh

cd /flash/rw/disk/pub/static-bins
./mtd erase RouterBoot || exit 1
nc 172.20.1.77 1111 | ./mtd write - RouterBoot
sync
#/sbin/sysinit reboot
