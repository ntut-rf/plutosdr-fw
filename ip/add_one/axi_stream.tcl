set ip_name add_one

# Open Project & Set Top-level Function
open_project ${ip_name}.prj
set_top ${ip_name}

# Add Files
add_files ${ip_name}.cpp

# Add Test Bench Files
add_files -tb ${ip_name}_tb.cpp

# Solutions : AXI4-Stream
open_solution AXI4-Stream
set_part {xc7z020clg484-1}
create_clock -period 10 -name default

config_rtl -prefix "axis_"

csim_design
csynth_design
export_design -format ip_catalog
close_solution

exit
