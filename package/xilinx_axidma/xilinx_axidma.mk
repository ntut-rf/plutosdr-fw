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

XILINX_AXIDMA_MODULE_SUBDIRS = driver

export AXIDMA_MODULE_NAME = axidma
export AXIDMA_FILES = axi_dma.c axidma_chrdev.c axidma_dma.c axidma.h axidma_of.c
export AXIDMA_INC_DIRS = $(@D)/include
$(eval $(kernel-module))

define XILINX_AXIDMA_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) CFLAGS+="-Wno-error" CROSS_COMPILE=arm-buildroot-linux-gnueabihf- ARCH=arm examples library
endef

define XILINX_AXIDMA_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/outputs/*.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 755 $(@D)/outputs/{axidma_benchmark,axidma_display_image,axidma_transfer} $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))
