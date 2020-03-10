
source -notrace $ad_hdl_dir/projects/pluto/system_bd.tcl

## gpreg

# ad_ip_instance axi_simplereg axi_simplereg_0
# ad_cpu_interconnect 0x40000000 axi_simplereg_0

## add_one (lite)

# ad_ip_instance axil_add_one axil_add_one_0
# ad_cpu_interconnect 0x41000000 axil_add_one_0

## AXI DMA

ad_ip_parameter sys_ps7 CONFIG.PCW_USE_S_AXI_HP0 1
ad_ip_instance axi_dma axi_dma_0
ad_ip_parameter axi_dma_0 CONFIG.c_sg_include_stscntrl_strm 0
ad_ip_parameter axi_dma_0 CONFIG.c_sg_length_width 23
ad_cpu_interconnect 0x42000000 axi_dma_0
ad_connect sys_cpu_clk axi_dma_0/m_axi_sg_aclk
ad_connect sys_cpu_clk axi_dma_0/m_axi_mm2s_aclk
ad_connect sys_cpu_clk axi_dma_0/m_axi_s2mm_aclk
ad_mem_hp0_interconnect sys_cpu_clk axi_dma_0/M_AXI_SG
ad_mem_hp0_interconnect sys_cpu_clk axi_dma_0/M_AXI_SG
ad_mem_hp0_interconnect sys_cpu_clk axi_dma_0/M_AXI_MM2S
ad_mem_hp0_interconnect sys_cpu_clk axi_dma_0/M_AXI_S2MM
ad_connect sys_ps7/FCLK_CLK0 axi_hp0_interconnect/S00_ACLK
ad_connect sys_ps7/FCLK_CLK0 axi_hp0_interconnect/M00_ACLK
ad_connect sys_ps7/FCLK_CLK0 axi_hp0_interconnect/S01_ACLK
ad_connect sys_ps7/FCLK_CLK0 axi_hp0_interconnect/S02_ACLK
ad_connect sys_cpu_resetn axi_hp0_interconnect/S00_ARESETN
ad_connect sys_cpu_resetn axi_hp0_interconnect/M00_ARESETN
ad_connect sys_cpu_resetn axi_hp0_interconnect/S01_ARESETN
ad_connect sys_cpu_resetn axi_hp0_interconnect/S02_ARESETN
ad_cpu_interrupt ps-0 mb-0 axi_dma_0/mm2s_introut
ad_cpu_interrupt ps-1 mb-1 axi_dma_0/s2mm_introut

ad_ip_parameter axi_dma_0 CONFIG.c_m_axis_mm2s_tdata_width 8

## FFT

# ad_ip_instance xfft xfft_0
# ad_connect axi_dma_0/M_AXIS_MM2S xfft_0/S_AXIS_DATA
# ad_connect axi_dma_0/S_AXIS_S2MM xfft_0/M_AXIS_DATA
# ad_ip_parameter xfft_0 CONFIG.data_format floating_point
# ad_ip_parameter xfft_0 CONFIG.transform_length 2048
# ad_ip_parameter xfft_0 CONFIG.target_data_throughput 5
# ad_ip_parameter xfft_0 CONFIG.output_ordering natural_order
# ad_connect sys_cpu_clk xfft_0/aclk

## axis_add_one

ad_ip_instance axis_add_one axis_add_one_0
ad_connect sys_cpu_clk axis_add_one_0/ap_clk
ad_connect sys_cpu_resetn axis_add_one_0/ap_rst_n
ad_connect axi_dma_0/M_AXIS_MM2S axis_add_one_0/A
ad_connect axi_dma_0/S_AXIS_S2MM axis_add_one_0/B

ad_ip_instance xlconstant xlconstant_0
ad_connect xlconstant_0/dout axis_add_one_0/ap_start

## Peripheral data interface

# ad_ip_parameter sys_ps7 CONFIG.PCW_USE_S_AXI_GP0 1
# ad_connect sys_ps7/FCLK_CLK0 sys_ps7/S_AXI_GP0_ACLK

# ad_ip_instance axi_interconnect axi_gp0_interconnect
# ad_ip_parameter axi_gp0_interconnect CONFIG.NUM_MI 1
# ad_ip_parameter axi_gp0_interconnect CONFIG.NUM_SI 1
# ad_connect sys_ps7/FCLK_CLK0 axi_gp0_interconnect/aclk
# ad_connect sys_cpu_resetn    axi_gp0_interconnect/aresetn
# ad_connect sys_ps7/S_AXI_GP0 axi_gp0_interconnect/M00_AXI
# ad_connect sys_ps7/FCLK_CLK0 axi_gp0_interconnect/M00_ACLK
# ad_connect sys_cpu_resetn    axi_gp0_interconnect/M00_ARESETN

## Microblaze

# ad_ip_instance microblaze microblaze_0
# apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config { \
#         axi_intc {0} \
#         axi_periph {Enabled} \
#         cache {None} \
#         clk {/sys_ps7/FCLK_CLK0 (100 MHz)} \
#         debug_module {Debug Only} \
#         ecc {None} \
#         local_mem {None} \
#         preset {Microcontroller} \
#     }  [get_bd_cells microblaze_0]
# ad_ip_parameter microblaze_0 CONFIG.C_I_LMB 1
# ad_ip_parameter microblaze_0 CONFIG.C_D_LMB 1

# ad_connect microblaze_0/M_AXI_DP axi_gp0_interconnect/S00_AXI
# ad_connect sys_ps7/FCLK_CLK0     axi_gp0_interconnect/S00_ACLK
# ad_connect sys_cpu_resetn        axi_gp0_interconnect/S00_ARESETN

# ad_ip_instance lmb_v10 ilmb_v10_0
# ad_connect sys_ps7/FCLK_CLK0            ilmb_v10_0/LMB_Clk
# ad_connect sys_rstgen/bus_struct_reset  ilmb_v10_0/SYS_Rst
# ad_connect microblaze_0/ILMB            ilmb_v10_0/LMB_M

# ad_ip_instance lmb_v10 dlmb_v10_0
# ad_connect sys_ps7/FCLK_CLK0            dlmb_v10_0/LMB_Clk
# ad_connect sys_rstgen/bus_struct_reset  dlmb_v10_0/SYS_Rst
# ad_connect microblaze_0/DLMB            dlmb_v10_0/LMB_M

# ad_ip_instance lmb_bram_if_cntlr lmb_bram_if_cntlr_0
# ad_ip_parameter lmb_bram_if_cntlr_0 CONFIG.C_NUM_LMB 2
# ad_connect sys_ps7/FCLK_CLK0            lmb_bram_if_cntlr_0/LMB_Clk
# ad_connect sys_rstgen/bus_struct_reset  lmb_bram_if_cntlr_0/LMB_Rst
# ad_connect ilmb_v10_0/LMB_Sl_0          lmb_bram_if_cntlr_0/SLMB
# ad_connect dlmb_v10_0/LMB_Sl_0          lmb_bram_if_cntlr_0/SLMB1

# ad_ip_instance axi_bram_ctrl     axi_bram_ctrl_0
# ad_ip_parameter axi_bram_ctrl_0 CONFIG.SINGLE_PORT_BRAM 1
# ad_cpu_interconnect 0x44000000          axi_bram_ctrl_0
# ad_connect sys_ps7/FCLK_CLK0            axi_bram_ctrl_0/s_axi_aclk

# ad_ip_instance blk_mem_gen lmb_bram_0
# ad_ip_parameter lmb_bram_0 CONFIG.Memory_Type True_Dual_Port_RAM
# ad_connect lmb_bram_if_cntlr_0/BRAM_PORT    lmb_bram_0/BRAM_PORTA
# ad_connect axi_bram_ctrl_0/BRAM_PORTA       lmb_bram_0/BRAM_PORTB

# set_property offset 0x10000000 [get_bd_addr_segs {microblaze_0/Data/SEG_sys_ps7_GP0_DDR_LOWOCM}]
# set_property range 256M [get_bd_addr_segs {microblaze_0/Data/SEG_sys_ps7_GP0_DDR_LOWOCM}]

assign_bd_address