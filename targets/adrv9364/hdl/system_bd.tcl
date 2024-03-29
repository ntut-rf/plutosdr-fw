source $ad_hdl_dir/projects/adrv9364z7020/common/adrv9364z7020_bd.tcl
source $ad_hdl_dir/projects/adrv9364z7020/common/ccbob_bd.tcl

cfg_ad9361_interface LVDS

set_property CONFIG.ADC_INIT_DELAY 30 [get_bd_cells axi_ad9361]

## AXI HP1, HP2

ad_connect sys_ps7/FCLK_CLK0 axi_hp1_interconnect/S00_ACLK
ad_connect sys_ps7/FCLK_CLK0 axi_hp1_interconnect/M00_ACLK
ad_connect sys_ps7/FCLK_CLK0 axi_hp2_interconnect/S00_ACLK
ad_connect sys_ps7/FCLK_CLK0 axi_hp2_interconnect/M00_ACLK

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

## FFT

ad_ip_parameter axi_dma_0 CONFIG.c_m_axis_mm2s_tdata_width 32

ad_ip_instance xfft xfft_0
ad_connect axi_dma_0/M_AXIS_MM2S xfft_0/S_AXIS_DATA
ad_connect axi_dma_0/S_AXIS_S2MM xfft_0/M_AXIS_DATA
ad_ip_parameter xfft_0 CONFIG.implementation_options radix_4_burst_io
ad_ip_parameter xfft_0 CONFIG.transform_length 2048
ad_ip_parameter xfft_0 CONFIG.output_ordering natural_order
ad_ip_parameter xfft_0 CONFIG.rounding_modes convergent_rounding
ad_ip_parameter xfft_0 CONFIG.complex_mult_type use_mults_performance
#ad_ip_parameter xfft_0 CONFIG.butterfly_type use_xtremedsp_slices
ad_connect sys_cpu_clk xfft_0/aclk

ad_ip_instance xlconstant xlconstant_0
ad_connect xlconstant_0/dout xfft_0/s_axis_config_tvalid

ad_ip_instance xlconstant xlconstant_1
ad_ip_parameter xlconstant_1 CONFIG.CONST_WIDTH 16
ad_ip_parameter xlconstant_1 CONFIG.CONST_VAL 1
ad_connect xlconstant_1/dout xfft_0/s_axis_config_tdata

## AXI DMA 1

ad_ip_instance axi_dma axi_dma_1
ad_ip_parameter axi_dma_1 CONFIG.c_sg_include_stscntrl_strm 0
ad_ip_parameter axi_dma_1 CONFIG.c_sg_length_width 23
ad_cpu_interconnect 0x44000000 axi_dma_1
ad_connect sys_cpu_clk axi_dma_1/m_axi_sg_aclk
ad_connect sys_cpu_clk axi_dma_1/m_axi_mm2s_aclk
ad_connect sys_cpu_clk axi_dma_1/m_axi_s2mm_aclk
ad_mem_hp0_interconnect sys_cpu_clk axi_dma_1/M_AXI_SG
ad_mem_hp0_interconnect sys_cpu_clk axi_dma_1/M_AXI_MM2S
ad_mem_hp0_interconnect sys_cpu_clk axi_dma_1/M_AXI_S2MM
ad_connect sys_ps7/FCLK_CLK0 axi_hp0_interconnect/S03_ACLK
ad_connect sys_ps7/FCLK_CLK0 axi_hp0_interconnect/S04_ACLK
ad_connect sys_ps7/FCLK_CLK0 axi_hp0_interconnect/S05_ACLK
ad_connect sys_cpu_resetn axi_hp0_interconnect/S03_ARESETN
ad_connect sys_cpu_resetn axi_hp0_interconnect/S04_ARESETN
ad_connect sys_cpu_resetn axi_hp0_interconnect/S05_ARESETN
ad_cpu_interrupt ps-2 mb-2 axi_dma_1/mm2s_introut
ad_cpu_interrupt ps-3 mb-3 axi_dma_1/s2mm_introut

## FFT 1

ad_ip_parameter axi_dma_1 CONFIG.c_m_axis_mm2s_tdata_width 32

ad_ip_instance xfft xfft_1
ad_connect axi_dma_1/M_AXIS_MM2S xfft_1/S_AXIS_DATA
ad_connect axi_dma_1/S_AXIS_S2MM xfft_1/M_AXIS_DATA
ad_ip_parameter xfft_1 CONFIG.implementation_options radix_4_burst_io
ad_ip_parameter xfft_1 CONFIG.transform_length 2048
ad_ip_parameter xfft_1 CONFIG.output_ordering natural_order
ad_ip_parameter xfft_1 CONFIG.rounding_modes convergent_rounding
ad_ip_parameter xfft_1 CONFIG.complex_mult_type use_mults_performance
#ad_ip_parameter xfft_1 CONFIG.butterfly_type use_xtremedsp_slices
ad_connect sys_cpu_clk xfft_1/aclk

ad_ip_instance xlconstant xlconstant_2
ad_connect xlconstant_2/dout xfft_1/s_axis_config_tvalid

ad_ip_instance xlconstant xlconstant_3
ad_ip_parameter xlconstant_3 CONFIG.CONST_WIDTH 16
ad_ip_parameter xlconstant_3 CONFIG.CONST_VAL 0
ad_connect xlconstant_3/dout xfft_1/s_axis_config_tdata

## AXI DMA 2

ad_ip_instance axi_dma axi_dma_2
ad_ip_parameter axi_dma_2 CONFIG.c_sg_include_stscntrl_strm 0
ad_ip_parameter axi_dma_2 CONFIG.c_sg_length_width 23
ad_cpu_interconnect 0x46000000 axi_dma_2
ad_connect sys_cpu_clk axi_dma_2/m_axi_sg_aclk
ad_connect sys_cpu_clk axi_dma_2/m_axi_mm2s_aclk
ad_connect sys_cpu_clk axi_dma_2/m_axi_s2mm_aclk
ad_mem_hp0_interconnect sys_cpu_clk axi_dma_2/M_AXI_SG
ad_mem_hp0_interconnect sys_cpu_clk axi_dma_2/M_AXI_MM2S
ad_mem_hp0_interconnect sys_cpu_clk axi_dma_2/M_AXI_S2MM
ad_connect sys_ps7/FCLK_CLK0 axi_hp0_interconnect/S06_ACLK
ad_connect sys_ps7/FCLK_CLK0 axi_hp0_interconnect/S07_ACLK
ad_connect sys_ps7/FCLK_CLK0 axi_hp0_interconnect/S08_ACLK
ad_connect sys_cpu_resetn axi_hp0_interconnect/S06_ARESETN
ad_connect sys_cpu_resetn axi_hp0_interconnect/S07_ARESETN
ad_connect sys_cpu_resetn axi_hp0_interconnect/S08_ARESETN
ad_cpu_interrupt ps-4 mb-4 axi_dma_2/mm2s_introut
ad_cpu_interrupt ps-5 mb-5 axi_dma_2/s2mm_introut

ad_ip_parameter axi_dma_2 CONFIG.c_s_axis_s2mm_tdata_width.VALUE_SRC USER
ad_ip_parameter axi_dma_2 CONFIG.c_s_axis_s2mm_tdata_width 64
ad_ip_parameter axi_dma_2 CONFIG.c_m_axi_s2mm_data_width.VALUE_SRC USER
ad_ip_parameter axi_dma_2 CONFIG.c_m_axi_s2mm_data_width 64

## ofdm_symb_acq

set_property ip_repo_paths {../../../hdl/library ../../../../SISO/ip} [current_project]
update_ip_catalog

ad_ip_instance ofdm_symb_acq ofdm_symb_acq0
ad_connect axi_dma_2/M_AXIS_MM2S ofdm_symb_acq0/in_r
ad_connect axi_dma_2/S_AXIS_S2MM ofdm_symb_acq0/out_r
ad_connect sys_ps7/FCLK_CLK0 ofdm_symb_acq0/ap_clk
ad_connect sys_cpu_resetn ofdm_symb_acq0/ap_rst_n

ad_ip_instance xlconstant xlconstant_4
ad_ip_parameter xlconstant_4 CONFIG.CONST_VAL 1
ad_connect xlconstant_4/dout ofdm_symb_acq0/ap_start

## assign_bd_address

assign_bd_address