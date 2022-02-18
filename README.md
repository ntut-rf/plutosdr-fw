# PlutoSDR / ADRV9364 Firmware 
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

## Build SDK in Ubuntu Docker

Build Docker image:
```console
$ make docker
```

Log in Docker image and build SDK:
```console
$ make docker-run
[docker] $ make sdk
```

## Install Xilinx Vivado

On ArchLinux,
```
$ sudo pacman -S ncurses5-compat-libs lib32-libpng12 xorg-xlsclients xorg-server-xvfb
```

## Set IP Address

For example,
```
# fw_setenv ipaddr 192.168.3.1
# fw_setenv ipaddr_host 192.168.3.10
```
Power off completely then power on.

## [Set sample rate](https://wiki.analog.com/resources/tools-software/linux-drivers/iio-transceiver/ad9361#settingquerying_the_tx_sample_rate)

> out_voltage_sampling_frequency as well as in_voltage_sampling_frequency are not entirely independent, by default the both need to match unless adi,fdd-rx-rate-2tx-enable is set.

## To do

* Time sync
* Separate toolchain
* Update hdl
* Package for hdl
* Package for Pluto specific stuff
* Fix for TX buffer clean
* Network / Mass storage settings
* Customize MOTD
* LED for ADRV9364
