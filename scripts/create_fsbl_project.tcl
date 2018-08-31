set hdl_project $::env(HDL_PROJECT)

hsi open_hw_design build/system_top.hdf
set cpu_name [lindex [hsi get_cells -filter {IP_TYPE==PROCESSOR}] 0]

sdk setws ./build/sdk
sdk createhw -name hw_0 -hwspec build/system_top.hdf
sdk createapp -name fsbl -hwproject hw_0 -proc $cpu_name -os standalone -lang C -app {Zynq FSBL}
configapp -app fsbl build-config release

# Hack to make fsbl build
file copy ./hdl/projects/$hdl_project/$hdl_project.srcs/sources_1/bd/system/ip/system_sys_ps7_0/ps7_init.h ./build/sdk/fsbl_bsp/ps7_cortexa9_0/include
file copy ./hdl/projects/$hdl_project/$hdl_project.srcs/sources_1/bd/system/ip/system_sys_ps7_0/ps7_init.c ./build/sdk/fsbl/src/

sdk projects -build -type all
#xsdk -batch -source create_fsbl_project.tcl
