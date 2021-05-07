set host_dir $::env(HOST_DIR)

hsi open_hw_design system_top.xsa
#set cpu_name [lindex [hsi get_cells -filter {IP_TYPE==PROCESSOR}] 0]
set cpu_name ps7_cortexa9_0

hsi set_repo_path $host_dir/share/device-tree-xlnx

hsi create_sw_design device-tree -os device_tree -proc $cpu_name

hsi generate_target -dir .