# plutosdr-fw
PlutoSDR Firmware for the [ADALM-PLUTO](https://wiki.analog.com/university/tools/pluto "PlutoSDR Wiki Page") Active Learning Module

Latest binary Release : [![GitHub release](https://img.shields.io/github/release/analogdevicesinc/plutosdr-fw.svg)](https://github.com/analogdevicesinc/plutosdr-fw/releases/latest)

[Instructions from the Wiki: Building the image](https://wiki.analog.com/university/tools/pluto/building_the_image)

* Build Instructions
 ```bash
      sudo apt-get install git build-essential fakeroot libncurses5-dev libssl-dev ccache 
      sudo apt-get install dfu-util u-boot-tools device-tree-compiler libssl1.0-dev mtools
      git clone --recursive https://github.com/analogdevicesinc/plutosdr-fw.git
      cd plutosdr-fw
      export CROSS_COMPILE=arm-xilinx-linux-gnueabi-
      export PATH=$PATH:/opt/Xilinx/SDK/2016.2/gnu/arm/lin/bin
      export VIVADO_SETTINGS=/opt/Xilinx/Vivado/2016.4/settings64.sh
      make
 
 ```
 If you receive an error similar to the following:
 ```
 Starting SDK. This could take few seconds... timeout while establishing a connection with SDK
    while executing
"error "timeout while establishing a connection with SDK""
    (procedure "getsdkchan" line 108)
    invoked from within
"getsdkchan"
    (procedure "createhw" line 26)
    invoked from within
"createhw {*}$args"
    (procedure "::sdk::create_hw_project" line 3)
    invoked from within
"sdk create_hw_project -name hw_0 -hwspec build/system_top.hdf"
    (file "scripts/create_fsbl_project.tcl" line 5)
```
you may be able to work around it by preventing eclipse from using GTK3 for the Standard Widget Toolkit (SWT). Prior to running make, also set the following environment variable: 
```bash
export SWT_GTK3=0
```
This problem seems to affect Ubuntu 16.04LTS only.

 * Updating your local repository 
 ```bash 
      git pull
      git submodule update --init --recursive
  ```
   
* Build Artifacts
 ```bash
      michael@HAL9000:~/devel/plutosdr-fw$ ls -AGhl build
	total 55M
	-rw-rw-r-- 1 michael   69 Okt  9 14:24 boot.bif
	-rw-rw-r-- 1 michael 446K Okt  9 14:24 boot.bin
	-rw-rw-r-- 1 michael 446K Okt  9 14:24 boot.dfu
	-rw-rw-r-- 1 michael 575K Okt  9 14:24 boot.frm
	-rw-rw-r-- 1 michael 8,8M Okt  9 14:24 pluto.dfu
	-rw-rw-r-- 1 michael 8,8M Okt  9 14:24 pluto.frm
	-rw-rw-r-- 1 michael   33 Okt  9 14:24 pluto.frm.md5
	-rw-rw-r-- 1 michael 8,8M Okt  9 14:24 pluto.itb
	-rw-rw-r-- 1 michael  17M Okt  9 14:24 plutosdr-fw-v0.23.zip
	-rw-rw-r-- 1 michael 466K Okt  9 14:24 plutosdr-jtag-bootstrap-v0.23.zip
	-rw-r--r-- 1 michael 4,7M Okt  9 14:23 rootfs.cpio.gz
	drwxrwxr-x 6 michael 4,0K Okt  9 14:24 sdk
	-rw-rw-r-- 1 michael 940K Okt  9 14:24 system_top.bit
	-rw-rw-r-- 1 michael 358K Okt  9 14:23 system_top.hdf
	-rwxrwxr-x 1 michael 409K Okt  9 14:24 u-boot.elf
	-rw-rw---- 1 michael 128K Okt  9 14:24 uboot-env.bin
	-rw-rw---- 1 michael 129K Okt  9 14:24 uboot-env.dfu
	-rw-rw-r-- 1 michael 4,6K Okt  9 14:24 uboot-env.txt
	-rwxrwxr-x 1 michael 3,2M Okt  9 14:23 zImage
	-rw-rw-r-- 1 michael  17K Okt  9 14:23 zynq-pluto-sdr.dtb
	-rw-rw-r-- 1 michael  17K Okt  9 14:23 zynq-pluto-sdr-revb.dtb
 ```
 
 * Main targets
 
     | File  | Comment |
     | ------------- | ------------- | 
     | pluto.frm | Main PlutoSDR firmware file used with the USB Mass Storage Device |
     | pluto.dfu | Main PlutoSDR firmware file used in DFU mode |
     | boot.frm  | First and Second Stage Bootloader (u-boot + fsbl + uEnv) used with the USB Mass Storage Device |
     | boot.dfu  | First and Second Stage Bootloader (u-boot + fsbl) used in DFU mode |
     | uboot-env.dfu  | u-boot default environment used in DFU mode |
     | plutosdr-fw-vX.XX.zip  | ZIP archive containg all of the files above |  
     | plutosdr-jtag-bootstrap-vX.XX.zip  | ZIP archive containg u-boot and Vivao TCL used for JATG bootstrapping |       
 
  * Other intermediate targets

     | File  | Comment |
     | ------------- | ------------- |
     | boot.bif | Boot Image Format file used to generate the Boot Image |
     | boot.bin | Final Boot Image |
     | pluto.frm.md5 | md5sum of the pluto.frm file |
     | pluto.itb | u-boot Flattened Image Tree |
     | rootfs.cpio.gz | The Root Filesystem archive |
     | sdk | Vivado/XSDK Build folder including  the FSBL |
     | system_top.bit | FPGA Bitstream (from HDF) |
     | system_top.hdf | FPGA Hardware Description  File exported by Vivado |
     | u-boot.elf | u-boot ELF Binary |
     | uboot-env.bin | u-boot default environment in binary format created form uboot-env.txt |
     | uboot-env.txt | u-boot default environment in human readable text format |
     | zImage | Compressed Linux Kernel Image |
     | zynq-pluto-sdr.dtb | Device Tree Blob for Rev.A |
     | zynq-pluto-sdr-revb.dtb | Device Tree Blob for Rev.B|     

 

