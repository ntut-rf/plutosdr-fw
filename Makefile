export VIVADO_VERSION ?= 2018.2
PATH := $(PATH):/opt/Xilinx/SDK/$(VIVADO_VERSION)/gnu/aarch32/lin/gcc-arm-linux-gnueabi/bin
VIVADO_SETTINGS ?= /opt/Xilinx/Vivado/$(VIVADO_VERSION)/settings64.sh

CROSS_COMPILE ?= arm-linux-gnueabihf-

VERSION = $(shell git describe --abbrev=4 --dirty --always --tags)
LATEST_TAG = $(shell git describe --abbrev=0 --tags)

ifdef TARGET
$(shell echo $(TARGET) > .target)
else
ifeq (,$(wildcard .target))
TARGET = pluto
else
TARGET = $(shell cat .target)
endif
endif

$(info TARGET: $(TARGET))
SUPPORTED_TARGETS := pluto sidekiqz2 adrv9364
$(if $(filter $(TARGET),$(SUPPORTED_TARGETS)),,$(error Invalid TARGET variable; valid values are: $(SUPPORTED_TARGETS)))

# Include target specific constants
include scripts/$(TARGET).mk

.PHONY: default
default: frm dfu

################################## Buildroot ###################################

.PHONY: patch
patch:
	for patch in configs/patches/*.patch; do \
		patch -d buildroot -p1 --forward < $$patch || true; \
	done

export BR2_EXTERNAL=$(CURDIR)/configs
export BR2_DEFCONFIG=$(CURDIR)/configs/$(TARGET)_defconfig
export O=$(CURDIR)/build/$(TARGET)/buildroot

## Pass targets to buildroot
%:
	$(MAKE) BR2_EXTERNAL=$(BR2_EXTERNAL) BR2_DEFCONFIG=$(BR2_DEFCONFIG) O=$(O) -C buildroot $*

menuconfig: $(O)/.config

## Making sure defconfig is already run
$(O)/.config: 
	$(MAKE) defconfig

## Import BR2_* definitions
include configs/$(TARGET)_defconfig

################################### Metadata ###################################

all: configs/msd/LICENSE.html

configs/msd/LICENSE.html: build/LICENSE.html
	cp $< $@

.PRECIOUS: build/LICENSE.html
build/LICENSE.html: configs/VERSIONS
	mkdir -p $(@D)
	$(MAKE) legal-info
	scripts/legal_info_html.sh "$(COMPLETE_NAME)" $<

configs/VERSIONS:
	echo device-fw $(VERSION) > $@
	echo hdl $(shell cd hdl && git describe --abbrev=4 --dirty --always --tags) >> $@
	echo linux $(BR2_LINUX_KERNEL_CUSTOM_REPO_VERSION) >> $@
	echo u-boot-xlnx $(BR2_TARGET_UBOOT_CUSTOM_REPO_VERSION) >> $@

################################### U-Boot #####################################

UBOOT_DIR = $(CURDIR)/buildroot/output/build/uboot-$(BR2_TARGET_UBOOT_CUSTOM_REPO_VERSION)

build/$(TARGET)/u-boot.elf:
	$(MAKE) uboot
	mkdir -p $(@D)
	cp buildroot/output/images/u-boot $@

build/$(TARGET)/uboot-env.bin: build/$(TARGET)/uboot-env.txt
	$(UBOOT_DIR)/tools/mkenvimage -s 0x20000 -o $@ $<

build/$(TARGET)/uboot-env.txt:
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
	$(LINUX_DIR)/scripts/diffconfig -m $< $(LINUX_DIR)/.config > configs/linux-extras-$(TARGET).config

#################################### Busybox ##################################

BUSYBOX_VERSION = $$(awk '/^BUSYBOX_VERSION/{print $$3}' buildroot/package/busybox/busybox.mk)
BUSYBOX_DIR = $(CURDIR)/buildroot/output/build/busybox-$(BUSYBOX_VERSION)

busybox-diffconfig: configs/busybox-1.25.0.config
	$(LINUX_DIR)/scripts/diffconfig -m $< $(BUSYBOX_DIR)/.config > configs/busybox-extras.config

###################################### HDL #####################################

.PHONY: hdl
hdl: build/$(TARGET)/sdk/hw_0/system_top.bit

build/$(TARGET)/sdk/fsbl/Release/fsbl.elf build/$(TARGET)/sdk/hw_0/system_top.bit: $(HDL_PROJECT_DIR)/$(HDL_PROJECT).sdk/system_top.hdf
	mkdir -p build/$(TARGET)
	source $(VIVADO_SETTINGS) && cd build/$(TARGET) && xsdk -batch -source $(CURDIR)/scripts/create_fsbl_project.tcl

$(HDL_PROJECT_DIR)/$(HDL_PROJECT).sdk/system_top.hdf:
	source $(VIVADO_SETTINGS) && $(MAKE) -C $(HDL_PROJECT_DIR)

#################################### Images ####################################

.PHONY: frm dfu
frm: build/$(TARGET)/$(TARGET).frm build/$(TARGET)/boot.frm
dfu: build/$(TARGET)/$(TARGET).dfu build/$(TARGET)/uboot-env.dfu build/$(TARGET)/boot.dfu

build/$(TARGET)/$(TARGET).itb: all hdl
	$(UBOOT_DIR)/tools/mkimage -f scripts/$(TARGET).its $@

build/$(TARGET)/boot.bif: build/$(TARGET)/sdk/fsbl/Release/fsbl.elf build/$(TARGET)/u-boot.elf
	echo img:{[bootloader] $^ } > $@

build/$(TARGET)/boot.bin: build/$(TARGET)/boot.bif
	source $(VIVADO_SETTINGS) && bootgen -image $< -w -o $@

### MSD update firmware file ###

build/$(TARGET)/$(TARGET).frm: build/$(TARGET)/$(TARGET).itb
	md5sum $< | cut -d ' ' -f 1 > $@.md5
	cat $< $@.md5 > $@

build/$(TARGET)/boot.frm: build/$(TARGET)/boot.bin build/$(TARGET)/uboot-env.bin scripts/target_mtd_info.key
	cat $^ | tee $@ | md5sum | cut -d ' ' -f1 | tee -a $@

### DFU update firmware file ###

build/$(TARGET)/$(TARGET).dfu: build/$(TARGET)/$(TARGET).itb
	cp $< $<.tmp
	dfu-suffix -a $<.tmp -v $(DEVICE_VID) -p $(DEVICE_PID)
	mv $<.tmp $@

build/$(TARGET)/%.dfu: build/$(TARGET)/%.bin
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

dfu-$(TARGET): build/$(TARGET)/$(TARGET).dfu
	dfu-util -D build/$(TARGET)/$(TARGET).dfu -a firmware.dfu
	dfu-util -e

dfu-sf-uboot: build/$(TARGET)/boot.dfu build/$(TARGET)/uboot-env.dfu
	dfu-util -D build/$(TARGET)/boot.dfu -a boot.dfu && \
	dfu-util -D build/$(TARGET)/uboot-env.dfu -a uboot-env.dfu
	dfu-util -e

dfu-all: build/$(TARGET)/$(TARGET).dfu build/$(TARGET)/boot.dfu build/$(TARGET)/uboot-env.dfu
	dfu-util -D build/$(TARGET)/$(TARGET).dfu -a firmware.dfu && \
	dfu-util -D build/$(TARGET)/boot.dfu -a boot.dfu  && \
	dfu-util -D build/$(TARGET)/uboot-env.dfu -a uboot-env.dfu
	dfu-util -e

dfu-ram: build/$(TARGET)/$(TARGET).dfu
	sshpass -p analog ssh root@$(TARGET).local '/usr/sbin/device_reboot ram;'
	sleep 5
	dfu-util -D build/$(TARGET)/$(TARGET).dfu -a firmware.dfu
	dfu-util -e

################################################################################

.PHONY: upload
upload:
	cp build/$(TARGET).frm /run/media/*/PlutoSDR/
	cp build/$(TARGET)/boot.frm /run/media/*/PlutoSDR/
	eject /run/media/$$USER/PlutoSDR

flash-%:
	umount /dev/$*2
	dd if=buildroot/output/images/rootfs.ext4 of=/dev/$*2 bs=4k
	sync