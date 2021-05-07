# ip

set ad_hdl_dir [file normalize $::env(ADI_HDL_DIR)]

source -notrace $ad_hdl_dir/library/scripts/adi_env.tcl
source -notrace $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create add2
adi_ip_files axi_simplereg [list \
  "$ad_hdl_dir/../ettus-fpga/usrp3/lib/dsp/add2.v" ]

adi_ip_properties_lite add2

ipx::save_core [ipx::current_core]

