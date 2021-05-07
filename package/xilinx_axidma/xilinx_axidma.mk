################################################################################
#
# xilinx_axidma
#
################################################################################

XILINX_AXIDMA_VERSION := 42ed91e
XILINX_AXIDMA_SITE := https://github.com/bperez77/xilinx_axidma.git
XILINX_AXIDMA_SITE_METHOD := git
XILINX_AXIDMA_INSTALL_STAGING := YES
XILINX_AXIDMA_INSTALL_TARGET := YES
XILINX_AXIDMA_DEPENDENCIES := linux

define XILINX_AXIDMA_BUILD_CMDS
	cd $(@D) && $(MAKE) $(TARGET_CONFIGURE_OPTS) CFLAGS+="-Wno-error" CROSS_COMPILE=arm-buildroot-linux-gnueabihf- ARCH=arm KBUILD_DIR=$(LINUX_DIR) driver
	cd $(@D) && $(MAKE) $(TARGET_CONFIGURE_OPTS) CFLAGS+="-Wno-error" CROSS_COMPILE=arm-buildroot-linux-gnueabihf- ARCH=arm examples library
endef

define XILINX_AXIDMA_INSTALL_STAGING_CMDS
	$(INSTALL) -D $(@D)/include/* $(STAGING_DIR)/usr/include/
endef

MODULES_DEP = $(TARGET_DIR)/usr/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep

define XILINX_AXIDMA_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/outputs/*.ko $(TARGET_DIR)/usr/lib/modules/$(LINUX_VERSION_PROBED)/kernel/
	grep -qxF 'kernel/axidma.ko:' $(MODULES_DEP) || echo 'kernel/axidma.ko:' >> $(MODULES_DEP)
	$(INSTALL) -D $(@D)/outputs/*.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 755 $(@D)/outputs/{axidma_benchmark,axidma_display_image,axidma_transfer} $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D $(@D)/outputs/libaxidma.so $(STAGING_DIR)/usr/lib/
	cp $(BR2_EXTERNAL)/package/xilinx_axidma/S46axidma $(TARGET_DIR)/etc/init.d/
endef

$(eval $(generic-package))
