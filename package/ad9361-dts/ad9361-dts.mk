################################################################################
#
# ad9361-dts
#
################################################################################

AD9361_DTS_VERSION = 0.1
AD9361_DTS_SITE_METHOD = local
AD9361_DTS_SITE := $(BR2_EXTERNAL)/package/ad9361-dts

define AD9361_DTS_BUILD_CMDS
	HDL_PROJECT=$(HDL_PROJECT) source $(VIVADO_SETTINGS) && cd $(O) && xsdk -batch -source $(@D)/generate_dts.tcl
	sed -i '/axi_ad9361/,/}/d' $(O)/dts/pl.dtsi
	sed -i '/misc_clk_0/,/}/d' $(O)/dts/pl.dtsi
	sed -i '/axi_ad9361_adc_dma/,/}/d' $(O)/dts/pl.dtsi
	sed -i '/axi_ad9361_dac_dma/,/}/d' $(O)/dts/pl.dtsi
	sed -i '/axi_iic_main/,/}/d' $(O)/dts/pl.dtsi
endef

$(eval $(generic-package))
