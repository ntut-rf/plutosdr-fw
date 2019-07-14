
source -notrace $ad_hdl_dir/projects/pluto/system_bd.tcl

# gpreg

ad_ip_instance axi_simplereg axi_simplereg_0
ad_cpu_interconnect 0x40000000 axi_simplereg_0

# add_one (lite)

ad_ip_instance lite_add_one lite_add_one_0
ad_cpu_interconnect 0x41000000 lite_add_one_0

# add_one (stream)

ad_ip_instance axi_dma axi_dma_0
ad_cpu_interconnect 0x42000000 axi_dma_0
ad_connect sys_cpu_clk axi_dma_0/m_axi_sg_aclk
ad_connect sys_cpu_clk axi_dma_0/m_axi_mm2s_aclk
ad_connect sys_cpu_clk axi_dma_0/m_axi_s2mm_aclk
ad_mem_hp0_interconnect sys_cpu_clk axi_dma_0/M_AXI_SG
ad_mem_hp0_interconnect sys_cpu_clk axi_dma_0/M_AXI_SG
ad_mem_hp0_interconnect sys_cpu_clk axi_dma_0/M_AXI_MM2S
ad_mem_hp0_interconnect sys_cpu_clk axi_dma_0/M_AXI_S2MM

ad_ip_instance axis_data_fifo axis_data_fifo_0
ad_connect sys_cpu_clk axis_data_fifo_0/s_axis_aclk
ad_connect sys_cpu_resetn axis_data_fifo_0/s_axis_aresetn
ad_connect axi_dma_0/S_AXIS_S2MM axis_data_fifo_0/M_AXIS
ad_connect axi_dma_0/M_AXIS_MM2S axis_data_fifo_0/S_AXIS

# ad_cpu_interrupt ps-0 mb-0 axi_dma_0/mm2s_introut
# ad_cpu_interrupt ps-1 mb-1 axi_dma_0/s2mm_introut

ad_ip_instance axi_intc axi_intc_0
ad_cpu_interconnect 0x43000000 axi_intc_0
ad_cpu_interrupt ps-14 mb-14 axi_intc_0/irq

ad_ip_instance xlconcat xlconcat_0
ad_connect xlconcat_0/dout axi_intc_0/intr
ad_connect axi_dma_0/mm2s_introut xlconcat_0/In0
ad_connect axi_dma_0/s2mm_introut xlconcat_0/In1