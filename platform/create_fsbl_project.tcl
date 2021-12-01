set hdl_project $::env(HDL_PROJECT)

hsi open_hw_design ./hdl/$hdl_project.sdk/system_top.xsa
#set cpu_name [lindex [hsi get_cells -filter {IP_TYPE==PROCESSOR}] 0]
set cpu_name ps7_cortexa9_0

sdk setws ./sdk
sdk createhw -name hw_0 -hwspec ./hdl/$hdl_project.sdk/system_top.xsa
sdk createapp -name fsbl -hwproject hw_0 -proc $cpu_name -os standalone -lang C -app {Zynq FSBL}
configapp -app fsbl build-config release

sdk projects -build -type all
#xsdk -batch -source create_fsbl_project.tcl
