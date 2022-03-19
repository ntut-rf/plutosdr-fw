
set ad_hdl_dir [file normalize $::env(ADI_HDL_DIR)]

source -notrace $ad_hdl_dir/projects/scripts/adi_env.tcl
source -notrace $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source -notrace $ad_hdl_dir/projects/scripts/adi_board.tcl

set lib_dirs "$ad_hdl_dir/../../SISO/ip"

set p_device "xc7z020clg400-1"
adi_project adrv9364z7020_ccbob_lvds

adi_project_files adrv9364z7020_ccbob_lvds [list \
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/adrv9364z7020/common/adrv9364z7020_constr.xdc" \
  "$ad_hdl_dir/projects/adrv9364z7020/common/adrv9364z7020_constr_lvds.xdc" \
  "$ad_hdl_dir/projects/adrv9364z7020/common/ccbob_constr.xdc" \
  "$ad_hdl_dir/projects/adrv9364z7020/ccbob_lvds/system_top.v" ]

adi_project_run adrv9364z7020_ccbob_lvds
source $ad_hdl_dir/library/axi_ad9361/axi_ad9361_delay.tcl

