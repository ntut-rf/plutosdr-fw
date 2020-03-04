# ip

set ad_hdl_dir [file normalize $::env(ADI_HDL_DIR)]
set library_name $::env(LIBRARY_NAME)
set library_src $::env(LIBRARY_SRC)

source -notrace $ad_hdl_dir/library/scripts/adi_env.tcl
source -notrace $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create $library_name
adi_ip_files $library_name [split $library_src " "]

adi_ip_properties_lite $library_name

ipx::save_core [ipx::current_core]

