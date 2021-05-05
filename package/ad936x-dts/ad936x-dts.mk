################################################################################
#
# ad936x-dts
#
################################################################################

AD936X_DTS_SITE_METHOD = local
AD936X_DTS_SITE := $(BR2_EXTERNAL)/package/ad936x-dts
AD936X_DTS_DEPENDENCIES = host-device-tree-xlnx ad936x-hdl

export HW_DESIGN = $(O)/images/system_top.hdf

define AD936X_DTS_BUILD_CMDS
	source $(VIVADO_SETTINGS) && xsdk -batch -source $(@D)/generate_dts.tcl

	# Delete nodes
	sed -i '/axi_ad9361/,/}/d' $(@D)/dts/pl.dtsi
	sed -i '/misc_clk_0/,/}/d' $(@D)/dts/pl.dtsi
	sed -i '/axi_ad9361_adc_dma/,/}/d' $(@D)/dts/pl.dtsi
	sed -i '/axi_ad9361_dac_dma/,/}/d' $(@D)/dts/pl.dtsi
	sed -i '/axi_iic_main/,/}/d' $(@D)/dts/pl.dtsi
	sed -i '/axi_sysid_0/,/}/d' $(@D)/dts/pl.dtsi
endef

$(eval $(generic-package))
