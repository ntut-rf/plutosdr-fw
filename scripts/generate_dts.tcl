set hdl_project $::env(HDL_PROJECT)

hsi open_hw_design ./hdl/$hdl_project.sdk/system_top.hdf
set cpu_name [lindex [hsi get_cells -filter {IP_TYPE==PROCESSOR}] 0]

hsi set_repo_path ../../device-tree-xlnx

hsi create_sw_design device-tree -os device_tree -proc $cpu_name

hsi generate_target -dir dts