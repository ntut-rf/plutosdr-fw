
source -notrace $ad_hdl_dir/projects/pluto/system_bd.tcl

# gpreg

ad_ip_instance axi_simplereg axi_simplereg
ad_cpu_interconnect 0x40000000 axi_simplereg

# my_mult

#ad_ip_instance my_mult_axis my_mult_axis_0
#ad_cpu_interconnect 0x41000000 my_mult_axis_0
