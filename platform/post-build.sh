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

rm -f ${TARGET_DIR}/opt/boot.vfat
rm -f ${TARGET_DIR}/etc/init.d/S99iiod

ln -sf device_reboot ${TARGET_DIR}/sbin/pluto_reboot

rm -rf ${TARGET_DIR}/usr/include/
rm -rf ${TARGET_DIR}/usr/lib/python3.8/site-packages/numpy/core/include/
rm -rf ${TARGET_DIR}/usr/lib/python3.8/distutils/command/*.exe
find ${TARGET_DIR}/usr/lib/python3.*/ -name 'tests' -exec rm -r '{}' +
find ${TARGET_DIR}/usr/lib/python3.*/ -name '*.pyo' -exec rm -r '{}' +