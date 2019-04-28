# ip

set ad_hdl_dir [file normalize $::env(ADI_HDL_DIR)]

source $ad_hdl_dir/library/scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_simplereg
adi_ip_files axi_simplereg [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "axi_simplereg.v" ]

adi_ip_properties axi_simplereg

ipx::save_core [ipx::current_core]

