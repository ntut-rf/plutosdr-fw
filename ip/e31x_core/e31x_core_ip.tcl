# ip

set ad_hdl_dir [file normalize $::env(ADI_HDL_DIR)]
set library_name $::env(LIBRARY_NAME)
set library_src $::env(LIBRARY_SRC)

source -notrace $ad_hdl_dir/library/scripts/adi_env.tcl
source -notrace $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create $library_name
adi_ip_files $library_name [split $library_src " "]

# Verilog defines (broken)
#set verilog_defs $::env(VERILOG_DEFS)
#set_property verilog_define [split $verilog_defs " "] [current_fileset]
set_property verilog_define {GIT_HASH=32'h0c75f3d0 RFNOC_EDGE_TBL_FILE=/home/en/plutosdr-fw/ettus-fpga/usrp3/top/e31x/e310_static_router.hex} [current_fileset]

report_ip_status
upgrade_ip [get_ips *]

adi_ip_properties $library_name

ipx::infer_bus_interface {\
    s_dma_tready \
    s_dma_tvalid \
    s_dma_tdata \
    s_dma_tlast \
    s_dma_tuser} \
  xilinx.com:interface:axis_rtl:1.0 [ipx::current_core]

ipx::infer_bus_interface {\
    m_dma_tready \
    m_dma_tvalid \
    m_dma_tdata \
    m_dma_tlast \
    m_dma_tdest} \
  xilinx.com:interface:axis_rtl:1.0 [ipx::current_core]

ipx::save_core [ipx::current_core]

