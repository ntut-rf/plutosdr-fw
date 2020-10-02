# PlutoSDR Firmware 
Customized firmware for the [PlutoSDR](https://wiki.analog.com/university/tools/pluto "PlutoSDR Wiki Page") and [ADRV9364-Z7020](https://www.analog.com/en/design-center/evaluation-hardware-and-software/evaluation-boards-kits/adrv9364-z7020.html).
Modified from [stock firmware](https://github.com/analogdevicesinc/plutosdr-fw).

## Instructions

* Build
 ```bash
$ git submodule update --init --recursive
$ make patch
$ make defconfig
$ make
 ```
 
* Upload firmware through MSD
 ```bash
 $ make upload
 ```
 
 * Login
 ```bash
 $ ssh root@pluto.local
 ```
 Password: `analog`

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
     
## Customizations

* Include hacks for [larger bandwidth](https://www.rtl-sdr.com/adalm-pluto-sdr-hack-tune-70-mhz-to-6-ghz-and-gqrx-install/) and [dual core](https://www.rtl-sdr.com/plutosdr-sdr-plugin-new-dual-core-cpu-hack/)
* Add [retrogram-plutosdr](https://github.com/r4d10n/retrogram-plutosdr)
* Add [GNU Radio](https://www.gnuradio.org/)
* Remove wifi and other firmware to save space
* Use xz compression to save space

 Note that the firmware boots slower than the official firmware.
 
 ## Frequency correction
 ```console
 # ad936x_ref_cal -e 860000000 /sys/bus/iio/devices/iio\:device1/
 ```
 To read the xo correction value,
 ```console
 # cat /sys/bus/iio/devices/iio\:device1/xo_correction
 ```
 
 ## MacOS
 ```console
 $ brew install gcc
 $ brew install coreutils
 $ brew install findutils
 $ export PATH=/usr/local/bin:$PATH
 $ cd /usr/local/bin
 $ ln -s gcc-10 gcc
 $ ln -s g++-10 g++
 $ ln -s ginstall install
 $ ln -s gfind find
 $ brew tap discoteq/discoteq
 $ brew install flock
 ```
