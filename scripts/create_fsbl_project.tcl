set hdl_project $::env(HDL_PROJECT)
set hdl_project_dir $::env(HDL_PROJECT_DIR)

hsi open_hw_design $hdl_project_dir/$hdl_project.sdk/system_top.hdf
set cpu_name [lindex [hsi get_cells -filter {IP_TYPE==PROCESSOR}] 0]

sdk setws ./sdk
sdk createhw -name hw_0 -hwspec $hdl_project_dir/$hdl_project.sdk/system_top.hdf
sdk createapp -name fsbl -hwproject hw_0 -proc $cpu_name -os standalone -lang C -app {Zynq FSBL}
configapp -app fsbl build-config release

# Hack to make fsbl build
file copy $hdl_project_dir/$hdl_project.srcs/sources_1/bd/system/ip/system_sys_ps7_0/ps7_init.h ./sdk/fsbl_bsp/ps7_cortexa9_0/include
file copy $hdl_project_dir/$hdl_project.srcs/sources_1/bd/system/ip/system_sys_ps7_0/ps7_init.c ./sdk/fsbl/src/

sdk projects -build -type all
#xsdk -batch -source create_fsbl_project.tcl
