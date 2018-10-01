# PlutoSDR Firmware 
Customized firmware for the [PlutoSDR](https://wiki.analog.com/university/tools/pluto "PlutoSDR Wiki Page")

## Customizations

* Include hacks for [larger bandwidth](https://www.rtl-sdr.com/adalm-pluto-sdr-hack-tune-70-mhz-to-6-ghz-and-gqrx-install/) and [dual core](https://www.rtl-sdr.com/plutosdr-sdr-plugin-new-dual-core-cpu-hack/)
* Add [my fork](https://github.com/seanstone/charon) of [Charon](https://github.com/tvelliott/charon)
* Add [liquid-dsp](http://liquidsdr.org/blog/)
* Add [GNU Radio](https://www.gnuradio.org/)
* Add [Python 2](https://www.python.org/)
* Add [FFTW](http://www.fftw.org/) with multiple precision (single and double) support
* Add [libfec](https://github.com/quiet/libfec) (dependency for [Charon](https://github.com/tvelliott/charon))
* Add [libtuntap](https://github.com/LaKabane/libtuntap) (dependency for [Charon](https://github.com/tvelliott/charon))
* Add NFS utils
* Add nano, htop
* Remove wifi and other firmware to save space
* Use xz compression to save space
* Updated versions of buildroot packages

## Instructions

* Build
 ```bash
$ git submodule update --init --recursive
$ make patch
$ make defconfig
$ make
 ```

 * Updating your local repository 
 ```bash 
  $ git pull
  $ git submodule update --init --recursive
  ```
 
## Build Artifacts

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

 

