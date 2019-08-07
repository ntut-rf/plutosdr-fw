################################################################################
#
# xilinx_axidma
#
################################################################################

XILINX_AXIDMA_VERSION := 42ed91e
XILINX_AXIDMA_SITE := https://github.com/bperez77/xilinx_axidma.git
XILINX_AXIDMA_SITE_METHOD := git
XILINX_AXIDMA_INSTALL_TARGET := YES
XILINX_AXIDMA_DEPENDENCIES := linux

define XILINX_AXIDMA_BUILD_CMDS
	cd $(@D) && $(MAKE) $(TARGET_CONFIGURE_OPTS) CFLAGS+="-Wno-error" CROSS_COMPILE=arm-buildroot-linux-gnueabihf- ARCH=arm KBUILD_DIR=$(LINUX_DIR) driver
	cd $(@D) && $(MAKE) $(TARGET_CONFIGURE_OPTS) CFLAGS+="-Wno-error" CROSS_COMPILE=arm-buildroot-linux-gnueabihf- ARCH=arm examples library
endef

KERNELVERSION := $(shell cd $(LINUX_DIR) && make -s kernelversion)
MODULES_DEP = $(TARGET_DIR)/usr/lib/modules/$(KERNELVERSION)/modules.dep

define XILINX_AXIDMA_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/outputs/*.ko $(TARGET_DIR)/usr/lib/modules/$(KERNELVERSION)/kernel/
	grep -qxF 'kernel/axidma.ko:' $(MODULES_DEP) || echo 'kernel/axidma.ko:' >> $(MODULES_DEP)
	$(INSTALL) -D $(@D)/outputs/*.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 755 $(@D)/outputs/{axidma_benchmark,axidma_display_image,axidma_transfer} $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))
