export SHELL:=/bin/bash

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
default: all

################################### Patches ####################################

.PHONY: patch
patch: patch-br

.PHONY: patch-br
patch-br:
	for patch in patches/buildroot/*.patch; do \
		patch -d buildroot -p1 --forward < $$patch || true; \
	done

################################## Buildroot ###################################

export BR2_EXTERNAL=$(CURDIR)
export BR2_DEFCONFIG=$(CURDIR)/targets/$(TARGET)/defconfig
export O=$(CURDIR)/build/$(TARGET)

all menuconfig: $(O)/.config

## Making sure defconfig is already run
$(O)/.config: 
	$(MAKE) defconfig

## Import BR2_* definitions
include $(BR2_DEFCONFIG)
HDL_PROJECT := $(patsubst "%",%,$(HDL_PROJECT))

all: xilinx_axidma-reinstall

################################### U-Boot #####################################

export UBOOT_DIR = $(strip $(O)/build/uboot-$(BR2_TARGET_UBOOT_CUSTOM_REPO_VERSION))

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

#################################### Buildroot ##################################

## Pass targets to buildroot
%:
	env - PATH=$(PATH) USER=$(USER) HOME=$(HOME) TERM=$(TERM) \
    	$(MAKE) TARGET=$(TARGET) BR2_EXTERNAL=$(BR2_EXTERNAL) BR2_DEFCONFIG=$(BR2_DEFCONFIG) O=$(O) \
		UBOOT_DIR=$(UBOOT_DIR) \
		-C buildroot $*

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

#################################### Clean #####################################

.PHONY: clean-target clean-images

clean-target:
	rm -rf $(O)/target
	find $(O) -name ".stamp_target_installed" | xargs rm -rf

clean-images:
	rm -f $(O)/images/*

##################################### DFU ######################################

.PHONY: dfu-fw dfu-uboot dfu-all dfu-ram

dfu-fw: $(O)/images/$(TARGET).dfu
	dfu-util -D $< -a firmware.dfu

boot.dfu: $(O)/images/boot.dfu 

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
flash-%: $(O)/images/sdcard.img
	@if lsblk -do name,tran | grep -E 'usb|mmcblk' | grep $*; then \
		(umount /dev/$*1 || true) && \
		(umount /dev/$*2 || true) && \
		dd if=$< of=/dev/$* bs=4k status=progress && \
		sync; \
		common/expand-rootfs.sh /dev/$*; \
		sync; partprobe; \
	else echo "Invalid device"; \
	fi

.PHONY: sync
sync:
	sshpass -p "analog" rsync -avz build/pluto/target/usr/bin root@pluto.local:/usr/
