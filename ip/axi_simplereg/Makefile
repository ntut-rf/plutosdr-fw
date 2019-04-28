
LIBRARY_NAME := axi_simplereg

GENERIC_DEPS += library/common/ad_rst.v
GENERIC_DEPS += library/common/up_axi.v
GENERIC_DEPS += $(LIBRARY_NAME).v

XILINX_DEPS += library/xilinx/common/ad_rst_constr.xdc
XILINX_DEPS += $(LIBRARY_NAME)_ip.tcl

include library/scripts/library.mk
