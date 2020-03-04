
LIBRARY_NAME := e31x_core

LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/top/e31x/e31x_core.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/top/e31x/e31x_rfnoc_image_core.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/axi/axi_data_swap.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/control/axil_regport_master.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/control/axi_setting_reg.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/control/db_control.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/control/gpio_atr.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/control/regport_resp_mux.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/control/simple_spi_core.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/control/synchronizer.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/control/synchronizer_impl.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/control/map/kv_map.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/fifo/axi_demux.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/fifo/axi_fifo.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/fifo/axi_fifo_2clk.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/fifo/axi_fifo_bram.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/fifo/axi_fifo_flop2.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/fifo/axi_fifo_short.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/fifo/axi_mux.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/rfnoc/blocks/rfnoc_block_radio/rfnoc_block_radio.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/rfnoc/core/chdr_data_swapper.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/rfnoc/core/chdr_mgmt_pkt_handler.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/rfnoc/core/chdr_stream_endpoint.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/rfnoc/core/rfnoc_core_kernel.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/rfnoc/crossbar/axis_switch.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/rfnoc/crossbar/chdr_xb_ingress_buff.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/rfnoc/crossbar/chdr_crossbar_nxn.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/rfnoc/utils/ctrlport_clk_cross.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/rfnoc/utils/ctrlport_to_settings_bus.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/rfnoc/utils/timekeeper.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/rfnoc/xport/chdr_xport_adapter_generic.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/rfnoc/xport/liberio_chdr64_adapter.v

TOOLS_DIR = $(ETTUS_FPGA_DIR)/usrp3/tools
GIT_HASH = $(shell $(TOOLS_DIR)/scripts/git-hash.sh --hashfile=$(TOOLS_DIR)/../../project.githash)
GIT_HASH_VERILOG_DEF = $(addprefix GIT_HASH=32'h,$(GIT_HASH))
EDGE_FILE = $(abspath $(ETTUS_FPGA_DIR)/usrp3/top/e31x/e310_static_router.hex)
EDGE_TBL_DEF = "RFNOC_EDGE_TBL_FILE=$(EDGE_FILE)"
VERILOG_DEFS = $(GIT_HASH_VERILOG_DEF) $(EDGE_TBL_DEF)
$(info $(VERILOG_DEFS))

GENERIC_DEPS += $(LIBRARY_SRC)
XILINX_DEPS += $(LIBRARY_NAME)_ip.tcl
export
include library/scripts/library.mk


