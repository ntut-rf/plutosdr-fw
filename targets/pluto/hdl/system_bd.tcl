
source -notrace $ad_hdl_dir/projects/pluto/system_bd.tcl

# gpreg

ad_ip_instance axi_simplereg axi_simplereg
ad_cpu_interconnect 0x40000000 axi_simplereg

# add_one

ad_ip_instance add_one add_one
ad_cpu_interconnect 0x41000000 add_one
