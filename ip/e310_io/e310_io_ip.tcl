# ip

set ad_hdl_dir [file normalize $::env(ADI_HDL_DIR)]

source -notrace $ad_hdl_dir/library/scripts/adi_env.tcl
source -notrace $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create e310_io
adi_ip_files e310_io [list \
  "$ad_hdl_dir/../ettus-fpga/usrp3/top/e31x/e310_io.v" \
  "$ad_hdl_dir/../ettus-fpga/usrp3/lib/control/synchronizer.v" \
  "$ad_hdl_dir/../ettus-fpga/usrp3/lib/control/synchronizer_impl.v" \
  ]

adi_ip_properties_lite e310_io

ipx::save_core [ipx::current_core]

