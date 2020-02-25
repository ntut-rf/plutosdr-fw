#!/bin/sh
# args from BR2_ROOTFS_POST_SCRIPT_ARGS
# $2    board name
set -e

#$(O)/images/$(TARGET).itb:
UBOOT_DIR=${O}/build/uboot-${BR2_TARGET_UBOOT_CUSTOM_REPO_VERSION}
${UBOOT_DIR}/tools/mkimage -f ${BR2_EXTERNAL}/targets/${TARGET}/${TARGET}.its ${O}/images/${TARGET}.itb

########################### DFU update firmware file ###########################

#$(O)/images/$(TARGET).dfu:
cp ${O}/images/${TARGET}.itb ${O}/images/${TARGET}.itb.tmp
dfu-suffix -a ${O}/images/${TARGET}.itb.tmp -v ${DEVICE_VID} -p ${DEVICE_PID}
mv ${O}/images/${TARGET}.itb.tmp ${O}/images/${TARGET}.dfu

#$(O)/images/%.dfu:
cp ${O}/images/uboot-env.bin ${O}/images/uboot-env.bin.tmp
dfu-suffix -a ${O}/images/uboot-env.bin.tmp -v ${DEVICE_VID} -p ${DEVICE_PID}
mv ${O}/images/uboot-env.bin.tmp ${O}/images/uboot-env.dfu

cp ${O}/images/boot.bin ${O}/images/boot.bin.tmp
dfu-suffix -a ${O}/images/boot.bin.tmp -v ${DEVICE_VID} -p ${DEVICE_PID}
mv ${O}/images/boot.bin.tmp ${O}/images/boot.dfu

########################### MSD update firmware file ###########################

#$(O)/images/$(TARGET).frm:
md5sum ${O}/images/${TARGET}.itb | cut -d ' ' -f 1 > ${O}/images/${TARGET}.frm.md5
cat ${O}/images/${TARGET}.itb ${O}/images/${TARGET}.frm.md5 > ${O}/images/${TARGET}.frm

#$(O)/images/boot.frm:
cat ${O}/images/boot.bin ${O}/images/uboot-env.bin ${BR2_EXTERNAL}/scripts/target_mtd_info.key | tee ${O}/images/boot.frm | md5sum | cut -d ' ' -f1 | tee -a ${O}/images/boot.frm