http://tom-itx.no-ip.biz:81/~webpage/emc/xilinx/xilinx14_install_index.php

I downloaded the 14.7 version. 

Xilinx_ISE_DS_Lin_14.7_1015_1.tar

After the huge download of Xilinx Design Suite run this installer and then follow this:

Navigate to the directory /opt/Xilinx/14.5/ISE_DS or where you installed Xilinx Design Suite.

run sudo su, then I THINK I ran: 
# source settings64.sh

and then
# ise

Then you need the zip file for 5i24 (which is compatible with your 6i24 board). 

Go to:

http://store.mesanet.com/index.php?route=product/product&product_id=298

and download the support software which gets you 5i24.zip

be sure to keep a back up of the zip file, and uncompress

in ISE, open up:

configs/hostmot2/source/fivei24.xise

it will ask some questions about migrating.
$ mkdir /home/owhite/IMPORTANT_FILES
$ cd IMPORTANT_FILES/
$ cp /home/owhite/5i24/configs/hostmot2/source/my_pin_5i24_72.vhd .
$ cp /home/owhite/5i24/configs/hostmot2/source/TopPCIHostMot2.bit . 

$ halcmd -kf
halcmd: loadrt hostmot2
halcmd: loadrt hm2_pci

when those two are loaded, that for some reason innoculates the system to allow this. But they arent needed every time after that. 
$ sudo mesaflash --device 5i24 --write TopPCIHostMot2.bit 
$ sudo mesaflash --device 5i24 --reload

Verify with:
$ sudo mesaflash --device 5i24 --readhmid
