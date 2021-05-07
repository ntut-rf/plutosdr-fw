# Open Project & Set Top-level Function
open_project add_one.prj
set_top add_one

# Add Files
add_files add_one.c

# Add Test Bench Files
add_files -tb add_one_tb.c

# Solutions : AXI4-Lite
open_solution AXI4-Lite
set_part {xc7z020clg484-1}
create_clock -period 10 -name default

config_rtl -prefix "axil_"

# Set Directives
set_directive_interface -mode s_axilite -bundle add_one_io "add_one"
set_directive_interface -mode s_axilite -bundle add_one_io "add_one" A
set_directive_interface -mode s_axilite -bundle add_one_io "add_one" B

csim_design
csynth_design
export_design -format ip_catalog
close_solution

exit
