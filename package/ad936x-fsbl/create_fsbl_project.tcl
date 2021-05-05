set hw_design $::env(HW_DESIGN)
set ws_dir $::env(WS_DIR)

hsi open_hw_design $hw_design
#set cpu_name [lindex [hsi get_cells -filter {IP_TYPE==PROCESSOR}] 0]
set cpu_name ps7_cortexa9_0

sdk setws $ws_dir
sdk createhw -name hw_0 -hwspec $hw_design
sdk createapp -name fsbl -hwproject hw_0 -proc $cpu_name -os standalone -lang C -app {Zynq FSBL}
configapp -app fsbl build-config release

sdk projects -build -type all