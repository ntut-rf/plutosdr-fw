COMPLETE_NAME:=ADRV9364Z7020
DEVICE_VID:=0x0456
DEVICE_PID:=0xb673
export HDL_PROJECT := adrv9364z7020_ccbob_lvds
export HDL_PROJECT_DIR := $(CURDIR)/hdl/projects/adrv9364z7020/ccbob_lvds/

FSBL_LOAD_BITSTREAM = 1

default: all