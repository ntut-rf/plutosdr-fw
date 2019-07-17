* pluto: load bitstream in fsbl
* ADRV9364: LED and GPIO
* ADRV9364: motd
* Generate mass storage vfat.img dynamically
* Generate axidma_chrdev node in dts:
```
    axidma_chrdev: axidma_chrdev@0 {
	compatible = "xlnx,axidma-chrdev";
	dmas = <&axi_dma_0 0 &axi_dma_0 1>;
	dma-names = "tx_channel", "rx_channel";
    };
```
* Fix dependency chain in Makefile (ip etc.)
* Configure IP in system_bd
* Use AXI interrupt controller
* Add microblaze etc.
* GNURadio integration
* Use https://github.com/bperez77/xilinx_axidma to test vdma
* Add a video encoder
