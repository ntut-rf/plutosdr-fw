* pluto: load bitstream in fsbl
* ADRV9364: LED and GPIO
* ADRV9364: motd
* Generate mass storage vfat.img dynamically
* Generate vdma test client node in dts:
```
    vdmatest_1: vdmatest@1 {
               compatible ="xlnx,axi-vdma-test-1.00.a";
               xlnx,num-fstores = <0x3>;
               dmas = <&axi_dma_0 0
                       &axi_dma_0 1>;
               dma-names = "vdma0", "vdma1";
        };
```
* Fix dependency chain in Makefile (ip etc.)
* Configure IP in system_bd
* Use AXI interrupt controller
* Add microblaze etc.
* GNURadio integration