################################################################################
#
# ad936x-dts
#
################################################################################

AD936X_DTS_SITE_METHOD = local
AD936X_DTS_SITE := $(BR2_EXTERNAL)/package/ad936x-dts
AD936X_DTS_DEPENDENCIES = host-device-tree-xlnx ad936x-hdl

define AD936X_DTS_BUILD_CMDS
	cp $(O)/images/system_top.xsa $(@D)
	cd $(@D) && source $(VIVADO_SETTINGS) && xsct $(@D)/generate_dts.tcl

	# Delete nodes
	sed -i '/axi_ad9361/,/}/d' $(@D)/pl.dtsi
	sed -i '/misc_clk_0/,/}/d' $(@D)/pl.dtsi
	sed -i '/axi_ad9361_adc_dma/,/}/d' $(@D)/pl.dtsi
	sed -i '/axi_ad9361_dac_dma/,/}/d' $(@D)/pl.dtsi
	sed -i '/axi_iic_main/,/}/d' $(@D)/pl.dtsi
	sed -i '/axi_sysid_0/,/}/d' $(@D)/pl.dtsi
endef

define AD936X_DTS_INSTALL_TARGET_CMDS
	cp $(@D)/pl.dtsi $(O)/images/
endef

$(eval $(generic-package))
