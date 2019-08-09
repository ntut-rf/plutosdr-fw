SHELL:=/bin/bash

export VIVADO_VERSION ?= 2019.1
VIVADO_SETTINGS ?= /opt/Xilinx/Vivado/$(VIVADO_VERSION)/settings64.sh

CROSS_COMPILE ?= arm-buildroot-linux-gnueabihf-

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
SUPPORTED_TARGETS := $(notdir $(wildcard targets/*))
$(if $(filter $(TARGET),$(SUPPORTED_TARGETS)),,$(error Invalid TARGET variable; valid values are: $(SUPPORTED_TARGETS)))

.PHONY: default

# Include target specific settings
include targets/$(TARGET)/$(TARGET).mk

################################## Buildroot ###################################

.PHONY: patch
patch:
	for patch in patches/*.patch; do \
		patch -d buildroot -p1 --forward < $$patch || true; \
	done

.PHONY: patch-hdl
patch-hdl:
	patch -d hdl -p1 --forward < hdl.patch || true

.PHONY: patch-dtg
patch-dtg:
	patch -d device-tree-xlnx -p1 --forward < device-tree-xlnx.patch || true

.PHONY: patch-ettus
patch-ettus:
	patch -d ettus-fpga -p1 --forward < ettus-fpga.patch || true

export BR2_EXTERNAL=$(CURDIR)
export BR2_DEFCONFIG=$(CURDIR)/targets/$(TARGET)/defconfig
export O=$(CURDIR)/build/$(TARGET)

## Pass targets to buildroot
%:
	$(MAKE) BR2_EXTERNAL=$(BR2_EXTERNAL) BR2_DEFCONFIG=$(BR2_DEFCONFIG) O=$(O) -C buildroot $*

all menuconfig: $(O)/.config

## Making sure defconfig is already run
$(O)/.config: 
	$(MAKE) defconfig

## Import BR2_* definitions
include $(BR2_DEFCONFIG)

all: xilinx_axidma-reinstall

################################### Metadata ###################################

all: build/LICENSE.html

build/LICENSE.html: build/VERSIONS
	mkdir -p $(@D)
	$(MAKE) legal-info
	scripts/legal_info_html.sh "$(COMPLETE_NAME)" $<

version = git describe --abbrev=4 --dirty --always --tags
build/VERSIONS:
	echo device-fw $$($(version)) > $@
	echo hdl $$(cd hdl && $(version)) >> $@
	echo linux $(BR2_LINUX_KERNEL_CUSTOM_REPO_VERSION) >> $@
	echo u-boot-xlnx $(BR2_TARGET_UBOOT_CUSTOM_REPO_VERSION) >> $@

################################### U-Boot #####################################

export UBOOT_DIR = $(strip $(O)/build/uboot-$(BR2_TARGET_UBOOT_CUSTOM_REPO_VERSION))

$(O)/images/u-boot.elf:
	$(MAKE) uboot-reconfigure
	mv $(O)/images/u-boot $@

$(O)/images/uboot-env.bin: $(O)/images/uboot-env.txt
	$(UBOOT_DIR)/tools/mkenvimage -s 0x20000 -o $@ $<

$(O)/images/uboot-env.txt:
	mkdir -p $(@D)
	cd $(@D) && PATH=$(CURDIR)/build/host/bin/:$(PATH) CROSS_COMPILE=$(CROSS_COMPILE) $(CURDIR)/scripts/get_default_envs.sh > $@
	echo attr_name=compatible >> $@
	echo attr_val=ad9364 >> $@
	sed -i 's,^\(maxcpus[ ]*=\).*,\1'2',g' $@

## Generate reference defconfig with missing options set to default as a base for comparison using diffconfig
$(UBOOT_DIR)/.$(BR2_TARGET_UBOOT_BOARD_DEFCONFIG)_defconfig:
	$(MAKE) -C $(UBOOT_DIR) KCONFIG_CONFIG=$@ $(BR2_TARGET_UBOOT_BOARD_DEFCONFIG)_defconfig

## Generate diff with reference config
uboot-diffconfig: $(UBOOT_DIR)/.$(BR2_TARGET_UBOOT_BOARD_DEFCONFIG)_defconfig linux-extract
	$(LINUX_DIR)/scripts/diffconfig -m $< $(UBOOT_DIR)/.config > $(BR2_TARGET_UBOOT_CONFIG_FRAGMENT_FILES)

#################################### Linux ####################################

export LINUX_DIR = $(strip $(O)/build/linux-$(BR2_LINUX_KERNEL_CUSTOM_REPO_VERSION))

## Generate reference defconfig with missing options set to default as a base for comparison using diffconfig
$(LINUX_DIR)/.$(BR2_LINUX_KERNEL_DEFCONFIG)_defconfig:
	$(MAKE) -C $(LINUX_DIR) KCONFIG_CONFIG=$@ ARCH=arm $(BR2_LINUX_KERNEL_DEFCONFIG)_defconfig

## Generate diff with reference config
linux-diffconfig: $(LINUX_DIR)/.$(BR2_LINUX_KERNEL_DEFCONFIG)_defconfig linux-extract
	$(LINUX_DIR)/scripts/diffconfig -m $< $(LINUX_DIR)/.config > $(BR2_LINUX_KERNEL_CONFIG_FRAGMENT_FILES)

#################################### Busybox ##################################

BUSYBOX_VERSION = $$(awk '/^BUSYBOX_VERSION/{print $$3}' buildroot/package/busybox/busybox.mk)
export BUSYBOX_DIR = $(strip $(O)/build/busybox-$(BUSYBOX_VERSION))

busybox-diffconfig: $(BR2_PACKAGE_BUSYBOX_CONFIG)
	$(LINUX_DIR)/scripts/diffconfig -m $< $(BUSYBOX_DIR)/.config > $(BR2_PACKAGE_BUSYBOX_CONFIG_FRAGMENT_FILES)

###################################### HDL #####################################

.PHONY: hdl
hdl: $(O)/sdk/hw_0/system_top.bit

.PHONY: fsbl
fsbl: $(O)/sdk/fsbl/Release/fsbl.elf

$(O)/sdk/fsbl/Release/fsbl.elf $(O)/sdk/hw_0/system_top.bit: $(O)/hdl/$(HDL_PROJECT).sdk/system_top.hdf
	mkdir -p $(O)
	source $(VIVADO_SETTINGS) && cd $(O) && xsdk -batch -source $(CURDIR)/scripts/create_fsbl_project.tcl

.PHONY: hdf
hdf: $(O)/hdl/$(HDL_PROJECT).sdk/system_top.hdf

$(O)/hdl/$(HDL_PROJECT).sdk/system_top.hdf:
	mkdir -p $(O)/hdl
	cp $(CURDIR)/targets/$(TARGET)/hdl/*.tcl $(O)/hdl/
	source $(VIVADO_SETTINGS) && \
		$(MAKE) ADI_HDL_DIR=$(CURDIR)/hdl VPATH=$(HDL_PROJECT_DIR) -I $(HDL_PROJECT_DIR) \
		-C $(O)/hdl -f $(CURDIR)/targets/$(TARGET)/hdl/Makefile

.PHONY: $(wildcard ip/*)
$(wildcard ip/*):
	mkdir -p $(CURDIR)/build/$@
	cp $@/* $(CURDIR)/build/$@
	source $(VIVADO_SETTINGS) && \
		$(MAKE) ADI_HDL_DIR=$(CURDIR)/hdl VPATH="$(CURDIR)/$@ $(CURDIR)/hdl" -I $(CURDIR)/hdl \
		-C $(CURDIR)/build/$@ -f $(CURDIR)/$@/Makefile

export
.PHONY: ettus
ettus:
	source $(VIVADO_SETTINGS) && \
		$(MAKE) -C ettus-fpga/usrp3/top/e300 GUI=1 HLS=1 E310_RFNOC

##################################### DTS ######################################

TARGET_DTSI := $(LINUX_DIR)/arch/arm/boot/dts/zynq-pluto-sdr.dtsi

.PHONY: dts clean-dts
dts:
	source $(VIVADO_SETTINGS) && cd $(O) && xsdk -batch -source $(CURDIR)/scripts/generate_dts.tcl
	sed -i '/axi_ad9361/,/}/d' $(O)/dts/pl.dtsi
	sed -i '/misc_clk_0/,/}/d' $(O)/dts/pl.dtsi
	sed -i '/axi_ad9361_adc_dma/,/}/d' $(O)/dts/pl.dtsi
	sed -i '/axi_ad9361_dac_dma/,/}/d' $(O)/dts/pl.dtsi
	sed -i '/axi_iic_main/,/}/d' $(O)/dts/pl.dtsi
	grep -qxF '/include/ "pl.dtsi"' $(TARGET_DTSI) || printf '\n/include/ "pl.dtsi"\n' >> $(TARGET_DTSI)
	grep -qxF '/include/ "user.dtsi"' $(TARGET_DTSI) || printf '\n/include/ "user.dtsi"\n' >> $(TARGET_DTSI)

#################################### Images ####################################

.PHONY: boot.bin
boot.bin: $(O)/images/boot.bin

all: $(O)/images/boot.bin

ifdef FSBL_LOAD_BITSTREAM
$(O)/images/boot.bif: $(O)/sdk/fsbl/Release/fsbl.elf $(O)/sdk/hw_0/system_top.bit $(O)/images/u-boot.elf
else
$(O)/images/boot.bif: $(O)/sdk/fsbl/Release/fsbl.elf $(O)/images/u-boot.elf
endif
	echo img:{[bootloader] $^ } > $@

$(O)/images/boot.bin: $(O)/images/boot.bif
	source $(VIVADO_SETTINGS) && bootgen -image $< -w -o $@

################################ Programming PL #################################

$(O)/images/system_top.bif: $(O)/hdl/$(TARGET).runs/impl_1/system_top.bit
	echo all:{$<} > $@

$(O)/images/system_top.bit.bin: $(O)/images/system_top.bif
	source $(VIVADO_SETTINGS) && bootgen -image $< -w -o $@

SSH_KEY = $(CURDIR)/platform/rootfs_overlay/root/.ssh/id_rsa

.PHONY: bit pl
bit: $(O)/images/system_top.bit.bin

pl: $(O)/images/system_top.bit.bin
	rsync -avzz -e "ssh -i $(SSH_KEY)" --chown=root:root $< root@$(TARGET).local:/lib/firmware
	ssh -i $(SSH_KEY) root@$(TARGET).local "echo system_top.bit.bin > /sys/class/fpga_manager/fpga0/firmware"

########################### DFU update firmware file ###########################

.PHONY: dfu
dfu: $(O)/images/$(TARGET).dfu $(O)/images/uboot-env.dfu $(O)/images/boot.dfu

$(O)/images/rootfs.cpio.xz:
	$(MAKE) all

$(O)/images/$(TARGET).itb: $(O)/images/rootfs.cpio.xz $(O)/sdk/hw_0/system_top.bit
	$(UBOOT_DIR)/tools/mkimage -f targets/$(TARGET)/$(TARGET).its $@

$(O)/images/$(TARGET).dfu: $(O)/images/$(TARGET).itb
	cp $< $<.tmp
	dfu-suffix -a $<.tmp -v $(DEVICE_VID) -p $(DEVICE_PID)
	mv $<.tmp $@

$(O)/images/%.dfu: $(O)/images/%.bin
	cp $< $<.tmp
	dfu-suffix -a $<.tmp -v $(DEVICE_VID) -p $(DEVICE_PID)
	mv $<.tmp $@

########################### MSD update firmware file ###########################

.PHONY: frm
frm: $(O)/images/$(TARGET).frm $(O)/images/boot.frm

$(O)/images/$(TARGET).frm: $(O)/images/$(TARGET).itb
	md5sum $< | cut -d ' ' -f 1 > $@.md5
	cat $< $@.md5 > $@

$(O)/images/boot.frm: $(O)/images/boot.bin $(O)/images/uboot-env.bin scripts/target_mtd_info.key
	cat $^ | tee $@ | md5sum | cut -d ' ' -f1 | tee -a $@

#################################### Clean #####################################

.PHONY: clean-all clean-sdk clean-hdl clean-hdllib clean-target

clean-all: clean-sdk clean-hdl clean-hdllib clean clean-ip

clean-sdk:
	rm -rf $(O)/sdk

clean-hdl: clean-sdk
	rm -rf $(O)/hdl

clean-ip:
	rm -rf build/ip

clean-hdllib:
	$(MAKE) -C hdl clean-all

clean-target:
	rm -rf $(O)/target
	find $(O) -name ".stamp_target_installed" |xargs rm -rf

clean-images:
	rm -f $(O)/images/*

clean-dts:
	rm -rf $(O)/dts

##################################### DFU ######################################

.PHONY: dfu-fw dfu-uboot dfu-all dfu-ram

dfu-fw: $(O)/images/$(TARGET).dfu
	dfu-util -D $< -a firmware.dfu

dfu-boot: $(O)/images/boot.dfu 
	dfu-util -D $< -a boot.dfu

dfu-boot-env: $(O)/images/uboot-env.dfu
	dfu-util -D $< -a uboot-env.dfu

dfu-all: dfu-fw dfu-boot dfu-boot-env

dfu-ram: $(O)/images/$(TARGET).dfu
	sshpass -p analog ssh root@$(TARGET).local '/usr/sbin/device_reboot ram;'
	sleep 5
	dfu-util -D $(O)/images/$(TARGET).dfu -a firmware.dfu
	dfu-util -e

################################################################################

.PHONY: upload
upload:
	cp $(O)/images/$(TARGET).frm /run/media/*/PlutoSDR/
	cp $(O)/images/boot.frm /run/media/*/PlutoSDR/
	sudo eject /run/media/$$USER/PlutoSDR

.PHONY: flash-%
flash-%:
	@if lsblk -do name,tran | grep usb | grep $*; then \
		(umount /dev/$*1 || true) && \
		(umount /dev/$*2 || true) && \
		dd if=$(O)/images/sdcard.img of=/dev/$* bs=4k status=progress && \
		sync; \
		scripts/expand-rootfs.sh /dev/$*; \
		sync; partprobe; \
	else echo "Invalid device"; \
	fi

.PHONY: upstream br-upstream update-msd update

upstream:
	git remote add -f -t master --no-tags upstream https://github.com/analogdevicesinc/plutosdr-fw.git || true

br-upstream:
	git remote add -f -t pluto --no-tags br-analog https://github.com/analogdevicesinc/buildroot.git || true

MSD_DIR = platform/msd
update-msd: br-upstream
	rm -rf $(MSD_DIR)
	git rm -rf $(MSD_DIR) || true
	git read-tree --prefix=$(MSD_DIR) -u br-analog/pluto:board/pluto/msd

update: br-upstream update-msd
	rm -rf build/update
	git rm -rf build/update || true
	mkdir -p build/update
	git read-tree --prefix=build/update -u br-analog/pluto:board/pluto
	git rm -rf --cached build/update
	mv build/update/S* platform/rootfs_overlay/etc/init.d/
	chmod +x platform/rootfs_overlay/etc/init.d/*
	mv build/update/{busybox-1.25.0.config,genimage-msd.cfg} platform/
	mv build/update/{device_config,fw_env.config,input-event-daemon.conf,mdev.conf,motd} platform/rootfs_overlay/etc/
	mv build/update/{device_reboot,udc_handle_suspend.sh,test_ensm_pinctrl.sh,update_frm.sh,update.sh} platform/rootfs_overlay/usr/sbin/
	chmod +x platform/rootfs_overlay/usr/sbin/*
	mv build/update/{automounter.sh,ifupdown.sh} platform/rootfs_overlay/usr/lib/mdev/
	chmod +x platform/rootfs_overlay/usr/lib/mdev/{automounter.sh,ifupdown.sh}

update-scripts: upstream
	rm -rf build/scripts
	git rm -rf build/scripts || true
	mkdir -p build/scripts
	git read-tree --prefix=build/scripts -u upstream/master:scripts
	git rm -rf --cached build/scripts
	mv build/scripts/{53-adi-plutosdr-usb.rules,create_fsbl_project.tcl,get_default_envs.sh,legal_info_html.sh,run.tcl,target_mtd_info.key} scripts/