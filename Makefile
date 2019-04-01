export VIVADO_VERSION ?= 2018.2
PATH := $(PATH):/opt/Xilinx/SDK/$(VIVADO_VERSION)/gnu/aarch32/lin/gcc-arm-linux-gnueabi/bin
VIVADO_SETTINGS ?= /opt/Xilinx/Vivado/$(VIVADO_VERSION)/settings64.sh

CROSS_COMPILE ?= arm-linux-gnueabihf-

NCORES = $(shell grep -c ^processor /proc/cpuinfo)

VERSION = $(shell git describe --abbrev=4 --dirty --always --tags)
LATEST_TAG = $(shell git describe --abbrev=0 --tags)

TARGET ?= pluto
SUPPORTED_TARGETS := pluto sidekiqz2 adrv9364z7020

TARGETS += build/$(TARGET).frm
TARGETS += build/boot.frm jtag-bootstrap

TARGETS += build/$(TARGET).dfu build/uboot-env.dfu
TARGETS += build/boot.dfu

ifeq ($(findstring $(TARGET),$(SUPPORTED_TARGETS)),)
all:
	@echo "Invalid TARGET variable ; valid values are: $(SUPPORTED_TARGETS)" &&
	exit 1
else
# Include target specific constants
include scripts/$(TARGET).mk
export HDL_PROJECT ?= $(TARGET)
export HDL_PROJECT_DIR ?= $(CURDIR)/hdl/projects/$(HDL_PROJECT)
all: $(TARGETS)
endif

################################## Buildroot ###################################

.PHONY: patch
patch:
	for patch in configs/patches/*.patch; do \
		patch -d buildroot -p1 --forward < $$patch || true; \
	done

## Pass targets to buildroot
%:
	$(MAKE) BR2_EXTERNAL=$(CURDIR)/configs BR2_DEFCONFIG=$(CURDIR)/configs/defconfig -C buildroot $*

menuconfig: buildroot/.config

## Making sure defconfig is already run
buildroot/.config: 
	$(MAKE) defconfig

## Import BR2_* definitions
include configs/defconfig

################################### Metadata ###################################

.PRECIOUS: build/LICENSE.html
build/LICENSE.html: configs/VERSIONS
	$(MAKE) legal-info
	scripts/legal_info_html.sh "$(COMPLETE_NAME)" $<

configs/VERSIONS:
	echo device-fw $(VERSION) > $@
	echo hdl $(shell cd hdl && git describe --abbrev=4 --dirty --always --tags) >> $@
	echo linux $(BR2_LINUX_KERNEL_CUSTOM_REPO_VERSION) >> $@
	echo u-boot-xlnx $(BR2_TARGET_UBOOT_CUSTOM_REPO_VERSION) >> $@

################################### U-Boot #####################################

export UIMAGE_LOADADDR=0x8000

build/u-boot.elf: uboot
	mkdir -p $(@D)
	cp buildroot/output/images/u-boot $@

build/uboot-env.bin: build/uboot-env.txt
	buildroot/output/build/uboot-$(BR2_TARGET_UBOOT_CUSTOM_REPO_VERSION)/tools/mkenvimage -s 0x20000 -o $@ $<

build/uboot-env.txt: uboot
	mkdir -p $(@D)
	CROSS_COMPILE=$(CROSS_COMPILE) scripts/get_default_envs.sh > $@
	echo attr_name=compatiable >> $@
	echo attr_val=ad9364 >> $@
	sed -i 's,^\(maxcpus[ ]*=\).*,\1'2',g' $@

#################################### Linux ####################################

LINUX_DIR = $(CURDIR)/buildroot/output/build/linux-$(BR2_LINUX_KERNEL_CUSTOM_REPO_VERSION)

## Generate reference defconfig with missing options set to default as a base for comparison using diffconfig
$(LINUX_DIR)/.$(BR2_LINUX_KERNEL_DEFCONFIG)_defconfig:
	$(MAKE) -C $(LINUX_DIR) KCONFIG_CONFIG=$@ ARCH=arm $(BR2_LINUX_KERNEL_DEFCONFIG)_defconfig

## Generate diff with reference config
linux-diffconfig: $(LINUX_DIR)/.$(BR2_LINUX_KERNEL_DEFCONFIG)_defconfig linux-extract
	$(LINUX_DIR)/scripts/diffconfig -m $< $(LINUX_DIR)/.config > configs/linux-extras.config

build/zImage: linux
	mkdir -p $(@D)
	cp buildroot/output/images/zImage $@

build/%.dtb: linux
	mkdir -p $(@D)
	cp buildroot/output/images/*.dtb $(@D)

#################################### Rootfs ####################################

.PHONY: rootfs
rootfs: build/rootfs.cpio.xz

build/rootfs.cpio.xz: build/LICENSE.html
	mkdir -p $(@D)
	cp build/LICENSE.html configs/msd/LICENSE.html
	$(MAKE) -C buildroot
	cp buildroot/output/images/rootfs.cpio.xz $@

###################################### HDL #####################################

.PHONY: hdl
hdl: build/$(TARGET)/system_top.bit

build/$(TARGET)/system_top.bit: build/$(TARGET)/sdk/hw_0/system_top.bit
	cp $< $@

build/$(TARGET)/sdk/fsbl/Release/fsbl.elf build/$(TARGET)/sdk/hw_0/system_top.bit: $(HDL_PROJECT_DIR)/$(HDL_PROJECT).sdk/system_top.hdf
	mkdir -p build/$(TARGET)
	source $(VIVADO_SETTINGS) && cd build/$(TARGET) && xsdk -batch -source $(CURDIR)/scripts/create_fsbl_project.tcl

$(HDL_PROJECT_DIR)/$(HDL_PROJECT).sdk/system_top.hdf:
	source $(VIVADO_SETTINGS) && $(MAKE) -C hdl/projects/$(HDL_PROJECT)

build/sdk/hw_0/ps7_init.tcl:
	cp $(HDL_PROJECT_DIR)/$(HDL_PROJECT).srcs/sources_1/bd/system/ip/system_sys_ps7_0/ps7_init.tcl $@

#################################### Images ####################################

.PHONY: itb
itb: build/$(TARGET).itb

build/$(TARGET).itb: uboot build/zImage build/rootfs.cpio.xz $(addprefix build/,$(TARGET_DTS_FILES)) build/system_top.bit
	buildroot/output/build/uboot-$(BR2_TARGET_UBOOT_CUSTOM_REPO_VERSION)/tools/mkimage -f scripts/$(TARGET).its $@

build/boot.bin: build/sdk/fsbl/Release/fsbl.elf build/u-boot.elf
	@echo img:{[bootloader] $^ } > build/boot.bif
	bash -c "source $(VIVADO_SETTINGS) && bootgen -image build/boot.bif -w -o $@"

################################### Products ###################################

.PHONY: fw frm dfu
fw: frm dfu

frm: build/$(TARGET).frm

dfu: build/$(TARGET).dfu

### MSD update firmware file ###

build/$(TARGET).frm: build/$(TARGET).itb
	md5sum $< | cut -d ' ' -f 1 > $@.md5
	cat $< $@.md5 > $@

build/boot.frm: build/boot.bin build/uboot-env.bin scripts/target_mtd_info.key
	cat $^ | tee $@ | md5sum | cut -d ' ' -f1 | tee -a $@

### DFU update firmware file ###

build/%.dfu: build/%.bin
	cp $< $<.tmp
	dfu-suffix -a $<.tmp -v $(DEVICE_VID) -p $(DEVICE_PID)
	mv $<.tmp $@

build/$(TARGET).dfu: build/$(TARGET).itb
	cp $< $<.tmp
	dfu-suffix -a $<.tmp -v $(DEVICE_VID) -p $(DEVICE_PID)
	mv $<.tmp $@

#################################### Clean #####################################

.PHONY: clean-all clean-build clean-hdl clean-target

clean-all: clean-build clean-hdl clean

clean-build:
	rm -rf build

clean-hdl:
	make -C hdl clean

clean-target:
	rm -rf buildroot/output/target
	find buildroot/output/ -name ".stamp_target_installed" |xargs rm -rf

##################################### DFU ######################################

.PHONY: dfu-$(TARGET) dfu-sf-uboot dfu-all dfu-ram

dfu-$(TARGET): build/$(TARGET).dfu
	dfu-util -D build/$(TARGET).dfu -a firmware.dfu
	dfu-util -e

dfu-sf-uboot: build/boot.dfu build/uboot-env.dfu
	echo "Erasing u-boot be careful - Press Return to continue... " && read key  && \
		dfu-util -D build/boot.dfu -a boot.dfu && \
		dfu-util -D build/uboot-env.dfu -a uboot-env.dfu
	dfu-util -e

dfu-all: build/$(TARGET).dfu build/boot.dfu build/uboot-env.dfu
	echo "Erasing u-boot be careful - Press Return to continue... " && read key && \
		dfu-util -D build/$(TARGET).dfu -a firmware.dfu && \
		dfu-util -D build/boot.dfu -a boot.dfu  && \
		dfu-util -D build/uboot-env.dfu -a uboot-env.dfu
	dfu-util -e

dfu-ram: build/$(TARGET).dfu
	sshpass -p analog ssh root@$(TARGET) '/usr/sbin/device_reboot ram;'
	sleep 5
	dfu-util -D build/$(TARGET).dfu -a firmware.dfu
	dfu-util -e

################################################################################

.PHONY: upload
upload:
	cp build/$(TARGET).frm /run/media/*/PlutoSDR/
	cp build/boot.frm /run/media/*/PlutoSDR/
	sudo eject /run/media/$$USER/PlutoSDR
