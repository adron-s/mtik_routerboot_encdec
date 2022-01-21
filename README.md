# Mikrotik RouterBOOT encoder/decoder

(C) Sergey Sergeev, 2022

All that you do is at your own risk!
The author has not liable for any of you actions and their consequences!
This code is presented as is and is solely for educational purposes ONLY! -
to learn how ARMv8 bootloaders works. In particular, to facilitate porting
OpenWRT to a new Mikrotik devices.

This set of scripts is intended for unpacking and obtaining binary
RouterBOOT file, which can later be studied in a Ghidra program.
This will allow OpenWRT developers to better understand the work
of RouterBOOT.

The first thing You need to do is to get the /dev/mtdblock2 dump from
your Mikrotik device (RB5009).
For this You can use my [Mikrotik initrd Jailbbeak](https://github.com/adron-s/mtik_initrd_hacks)
telnet x.x.x.x 22111 and then do:

	cat /dev/mtdblock2 | nc -l -p 1111

And on You PC:

	nc x.x.x.x 1111 > ./bins/mtdblock2.bin
	./get_from_mtd.sh

You should get two files:

	*.enc - UCL NRV2B encoded RouterBOOT
	*.dec - ARMv8 binary code(ready to be fed to Ghidra)

To pack dec file back(after making some modifications):

	./pack_to_fwf.sh && ./pack_to_mtd.sh

The result is on ./bins/mtdblock2-OWL.bin
Upload ./static-bins folder to Your mikrotik device(via ftp)
and write ./bins/mtdblock2-OWL.bin to it /dev/mtd2:

	cd /flash/rw/disk/pub/static-bins/
	./mtd erase RouterBOOT && nc 172.20.1.77 1111 | ./mtd write - RouterBOOT

If you just need to fix the UART work on RouterBOOT:

	Get the /dev/mtdblock2 dump from your Mikrotik device (RB5009)
	./uart_fixer.sh nc

