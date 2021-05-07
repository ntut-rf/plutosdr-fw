# ip

set ad_hdl_dir [file normalize $::env(ADI_HDL_DIR)]

source -notrace $ad_hdl_dir/library/scripts/adi_env.tcl
source -notrace $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_simplereg
adi_ip_files axi_simplereg [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "axi_simplereg.v" ]

adi_ip_properties axi_simplereg

ipx::save_core [ipx::current_core]

