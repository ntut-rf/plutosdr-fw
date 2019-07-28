# Open Project & Set Top-level Function
open_project add_one.prj
set_top add_one

# Add Files
add_files add_one.cpp

# Add Test Bench Files
add_files -tb add_one_tb.cpp

# Solutions : AXI4-Stream
open_solution AXI4-Stream
set_part {xc7z020clg484-1}
create_clock -period 10 -name default

config_rtl -prefix "axis_"

# Set Directives
set_directive_interface -mode ap_ctrl_hs "add_one"
# set_directive_interface -mode axis -depth 1 "add_one" A
# set_directive_interface -mode axis -depth 1 "add_one" B

csim_design
csynth_design
export_design -format ip_catalog
close_solution

exit
