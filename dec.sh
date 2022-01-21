#!/bin/sh

#for decode UCL NRV2B RouterBOOT

dd if=./bins/70x0-7.2rc1.fwf of=./bins/routerboot-7.2rc1.enc bs=4 skip=9
./nrv2b/nrv2b d ./bins/routerboot-7.2rc1.enc ./bins/routerboot-7.2rc1.dec

dd if=./bins/70x0-7.2rc1.fwf of=./bins/head.enc bs=4 count=8
