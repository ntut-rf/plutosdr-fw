#!/bin/sh
# args from BR2_ROOTFS_POST_SCRIPT_ARGS
# $2    board name
set -e

BOARD_DIR="$(dirname $0)"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

cp "${BOARD_DIR}/uEnv.txt" "${O}/images/"

rm -rf "${GENIMAGE_TMP}"
genimage                           \
	--rootpath "${TARGET_DIR}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${O}/images"  \
	--outputpath "${O}/images" \
	--config "${BOARD_DIR}/genimage-sdcard.cfg"