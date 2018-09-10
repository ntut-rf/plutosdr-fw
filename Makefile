export VIVADO_VERSION ?= 2018.2
PATH := $(PATH):/opt/Xilinx/SDK/$(VIVADO_VERSION)/gnu/aarch32/lin/gcc-arm-linux-gnueabi/bin
VIVADO_SETTINGS ?= /opt/Xilinx/Vivado/$(VIVADO_VERSION)/settings64.sh
HAVE_VIVADO ?= 1

CROSS_COMPILE ?= arm-linux-gnueabihf-

NCORES = $(shell grep -c ^processor /proc/cpuinfo)

VERSION=$(shell git describe --abbrev=4 --dirty --always --tags)
LATEST_TAG=$(shell git describe --abbrev=0 --tags)
HAVE_VIVADO= $(shell bash -c "source $(VIVADO_SETTINGS) > /dev/null 2>&1 && vivado -version > /dev/null 2>&1 && echo 1 || echo 0")

TARGET ?= pluto
SUPPORTED_TARGETS:=pluto sidekiqz2
export HDL_PROJECT ?= $(TARGET)

# Include target specific constants
include scripts/$(TARGET).mk

ifeq (, $(shell which dfu-suffix))
$(warning "No dfu-utils in PATH consider doing: sudo apt-get install dfu-util")
TARGETS = build/$(TARGET).frm
ifeq (1, ${HAVE_VIVADO})
TARGETS += build/boot.frm jtag-bootstrap
endif
else
TARGETS = build/$(TARGET).dfu build/uboot-env.dfu build/$(TARGET).frm
ifeq (1, ${HAVE_VIVADO})
TARGETS += build/boot.dfu build/boot.frm jtag-bootstrap
endif
endif

ifeq ($(findstring $(TARGET),$(SUPPORTED_TARGETS)),)
all:
	@echo "Invalid TARGET variable ; valid values are: pluto, sidekiqz2" &&
	exit 1
else
all: $(TARGETS) zip-all
endif

.NOTPARALLEL: all

TARGET_DTS_FILES:=$(foreach dts,$(TARGET_DTS_FILES),build/$(dts))

build:
	mkdir -p $@

buildroot/.config:
	$(MAKE) defconfig

### u-boot ###

export UIMAGE_LOADADDR=0x8000

uboot: | buildroot/.config

.PHONY: buildroot/output/images/u-boot buildroot/output/build/uboot-pluto/tools/mkimage
buildroot/output/images/u-boot buildroot/output/build/uboot-pluto/tools/mkimage: uboot

build/u-boot.elf: buildroot/output/images/u-boot | build
	cp $< $@

build/uboot-env.txt: uboot | build
	CROSS_COMPILE=$(CROSS_COMPILE) scripts/get_default_envs.sh > $@

build/uboot-env.bin: build/uboot-env.txt
	buildroot/output/build/uboot-pluto/tools/mkenvimage -s 0x20000 -o $@ $<

### Linux ###

linux: | buildroot/.config

.PHONY: buildroot/output/images/zImage
buildroot/output/images/zImage: linux

build/zImage: buildroot/output/images/zImage  | build
	cp $< $@

### Device Tree ###

buildroot/output/images/%.dtb: linux

build/%.dtb: buildroot/output/images/%.dtb | build
	cp $< $@

### Buildroot ###

buildroot/board/$(TARGET)/VERSIONS:
	@echo device-fw $(VERSION) > $(CURDIR)/buildroot/board/$(TARGET)/VERSIONS
	@echo hdl $(shell cd hdl && git describe --abbrev=4 --dirty --always --tags) >> $(CURDIR)/buildroot/board/$(TARGET)/VERSIONS
	@echo linux master >> $(CURDIR)/buildroot/board/$(TARGET)/VERSIONS
	@echo u-boot-xlnx pluto >> $(CURDIR)/buildroot/board/$(TARGET)/VERSIONS

.PRECIOUS: build/LICENSE.html
build/LICENSE.html: buildroot/board/$(TARGET)/VERSIONS
	$(MAKE) -C buildroot legal-info
	scripts/legal_info_html.sh "$(COMPLETE_NAME)" "$(CURDIR)/buildroot/board/$(TARGET)/VERSIONS"

.PHONY: rootfs
rootfs: | build/LICENSE.html buildroot/.config
	cp build/LICENSE.html buildroot/board/$(TARGET)/msd/LICENSE.html
	$(MAKE) -C buildroot

.PHONY: buildroot/output/images/rootfs.cpio.gz
buildroot/output/images/rootfs.cpio.gz: rootfs

build/rootfs.cpio.gz: buildroot/output/images/rootfs.cpio.gz | build
	cp $< $@

## Pass targets to buildroot
%:
	$(MAKE) BR2_EXTERNAL=$(CURDIR)/configs BR2_DEFCONFIG=$(CURDIR)/configs/config -C buildroot $*

.PHONY: hdl
hdl: build/system_top.hdf

.PHONY: build/system_top.hdf
build/system_top.hdf:  | build
ifeq (1, ${HAVE_VIVADO})
	cd hdl && patch --forward -p1 < ../patches/pluto.patch || true
	bash -c "source $(VIVADO_SETTINGS) && make -C hdl/projects/$(HDL_PROJECT) && cp hdl/projects/$(HDL_PROJECT)/$(HDL_PROJECT).sdk/system_top.hdf $@"
else
ifneq ($(HDF_URL),)
	wget -T 3 -t 1 -N --directory-prefix build $(HDF_URL)
endif
endif

build/$(TARGET).itb: buildroot/output/build/uboot-pluto/tools/mkimage build/zImage build/rootfs.cpio.gz $(TARGET_DTS_FILES) build/system_top.bit
	buildroot/output/build/uboot-pluto/tools/mkimage -f scripts/$(TARGET).its $@

### TODO: Build system_top.hdf from src if dl fails - need 2016.2 for that ...

build/sdk/fsbl/Release/fsbl.elf build/sdk/hw_0/system_top.bit : build/system_top.hdf
	rm -Rf build/sdk
ifeq (1, ${HAVE_VIVADO})
	bash -c "source $(VIVADO_SETTINGS) && xsdk -batch -source scripts/create_fsbl_project.tcl"
else
	mkdir -p build/sdk/hw_0
	unzip -o build/system_top.hdf system_top.bit -d build/sdk/hw_0
endif

build/system_top.bit: build/sdk/hw_0/system_top.bit
	cp $< $@

build/boot.bin: build/sdk/fsbl/Release/fsbl.elf build/u-boot.elf
	@echo img:{[bootloader] $^ } > build/boot.bif
	bash -c "source $(VIVADO_SETTINGS) && bootgen -image build/boot.bif -w -o $@"

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

clean-build:
	rm -f $(notdir $(wildcard build/*))
	rm -rf build/*

clean:
	make -C buildroot clean
	make -C hdl clean
	rm -f $(notdir $(wildcard build/*))
	rm -rf build/*

zip-all: $(TARGETS)
	zip -j build/$(ZIP_ARCHIVE_PREFIX)-fw-$(VERSION).zip $^

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

jtag-bootstrap: build/u-boot.elf build/sdk/hw_0/ps7_init.tcl build/sdk/hw_0/system_top.bit scripts/run.tcl
	$(CROSS_COMPILE)strip build/u-boot.elf
	zip -j build/$(ZIP_ARCHIVE_PREFIX)-$@-$(VERSION).zip $^

sysroot: buildroot/output/images/rootfs.cpio.gz
	tar czfh build/sysroot-$(VERSION).tar.gz --hard-dereference --exclude=usr/share/man -C buildroot/output staging

legal-info: buildroot/output/images/rootfs.cpio.gz
	tar czvf build/legal-info-$(VERSION).tar.gz -C buildroot/output legal-info

git-update-all:
	git submodule update --recursive --remote

git-pull:
	git pull --recurse-submodules

.PHONY: fw
fw: build/$(TARGET).frm build/$(TARGET).dfu

.PHONY: upload
upload:
	cp build/$(TARGET).frm /run/media/*/PlutoSDR/
	cp build/boot.frm /run/media/*/PlutoSDR/
	sudo eject /run/media/$$USER/PlutoSDR

build/sdk/hw_0/ps7_init.tcl:
	cp hdl/projects/$(HDL_PROJECT)/$(HDL_PROJECT).srcs/sources_1/bd/system/ip/system_sys_ps7_0/ps7_init.tcl $@
