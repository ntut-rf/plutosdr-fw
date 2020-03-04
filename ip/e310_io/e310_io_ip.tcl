# ip

set ad_hdl_dir [file normalize $::env(ADI_HDL_DIR)]
set ettus_fpga_dir [file normalize $::env(ETTUS_FPGA_DIR)]

source -notrace $ad_hdl_dir/library/scripts/adi_env.tcl
source -notrace $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create e310_io
adi_ip_files e310_io [list \
  "$ettus_fpga_dir/usrp3/top/e31x/e310_io.v" \
  "$ettus_fpga_dir/usrp3/lib/control/synchronizer.v" \
  "$ettus_fpga_dir/usrp3/lib/control/synchronizer_impl.v" \
  ]

adi_ip_properties_lite e310_io

ipx::save_core [ipx::current_core]

