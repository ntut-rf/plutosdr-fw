
set ad_hdl_dir [file normalize $::env(ADI_HDL_DIR)]

source -notrace $ad_hdl_dir/projects/scripts/adi_env.tcl
source -notrace $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source -notrace $ad_hdl_dir/projects/scripts/adi_board.tcl

set lib_dirs "~/SISO"

set p_device "xc7z010clg225-1"
adi_project pluto

adi_project_files pluto [list \
  "$ad_hdl_dir/projects/pluto/system_top.v" \
  "$ad_hdl_dir/projects/pluto/system_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v"]

set_property is_enabled false [get_files  *system_sys_ps7_0.xdc]
adi_project_run pluto
source -notrace $ad_hdl_dir/library/axi_ad9361/axi_ad9361_delay.tcl
