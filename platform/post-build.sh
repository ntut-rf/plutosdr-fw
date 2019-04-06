#!/bin/sh
# args from BR2_ROOTFS_POST_SCRIPT_ARGS
# $2    board name
set -e

INSTALL=install

# Add a console on tty1
grep -qE '^ttyGS0::' ${TARGET_DIR}/etc/inittab || \
sed -i '/GENERIC_SERIAL/a\
ttyGS0::respawn:/sbin/getty -L ttyGS0 0 vt100 # USB console' ${TARGET_DIR}/etc/inittab

grep -qE '^::sysinit:/bin/mount -t debugfs' ${TARGET_DIR}/etc/inittab || \
sed -i '/hostname/a\
::sysinit:/bin/mount -t debugfs none /sys/kernel/debug/' ${TARGET_DIR}/etc/inittab

sed -i -e '/::sysinit:\/bin\/hostname -F \/etc\/hostname/d' ${TARGET_DIR}/etc/inittab

BOARD_DIR="$(dirname $0)"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

MSD_DIR="${BOARD_DIR}/msd"

cp ${O}/../LICENSE.html ${MSD_DIR}

rm -rf "${GENIMAGE_TMP}"
genimage                           \
	--rootpath "${TARGET_DIR}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${MSD_DIR}"  \
	--outputpath "${TARGET_DIR}/opt/" \
	--config "${BOARD_DIR}/genimage-msd.cfg"

rm -f ${TARGET_DIR}/opt/boot.vfat
rm -f ${TARGET_DIR}/etc/init.d/S99iiod

${INSTALL} -D -m 0644 ${O}/../VERSIONS ${TARGET_DIR}/opt/

mkdir -p ${TARGET_DIR}/www/img
${INSTALL} -D -m 0644 ${MSD_DIR}/img/* ${TARGET_DIR}/www/img/
${INSTALL} -D -m 0644 ${MSD_DIR}/index.html ${TARGET_DIR}/www/

ln -sf device_reboot ${TARGET_DIR}/sbin/pluto_reboot

rm -rf ${TARGET_DIR}/usr/include/
rm -rf ${TARGET_DIR}/usr/lib/python2.7/site-packages/numpy/core/include/
rm -rf ${TARGET_DIR}/usr/lib/python2.7/distutils/command/*.exe