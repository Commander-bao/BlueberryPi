#!/bin/bash -e

TARGET_ROOTFS_DIR=./binary

if [ $RK_ROOTFS_IMAGE ]; then
	ROOTFSIMAGE=$RK_ROOTFS_IMAGE
else
	ROOTFSIMAGE=ubuntu-$TARGET-rootfs.img
fi

echo Making rootfs!

if [ -e ${ROOTFSIMAGE} ]; then
	rm ${ROOTFSIMAGE}
fi

# for script in ./post-build.sh ../device/rockchip/common/post-build.sh; do
# 	[ -x $script ] || continue
# 	sudo $script "$(realpath "$TARGET_ROOTFS_DIR")"
# done

sudo ./add-build-info.sh ${TARGET_ROOTFS_DIR}

EXTRA_SIZE_MB=200
IMAGE_SIZE_MB=$(( $(sudo du -sh -m ${TARGET_ROOTFS_DIR} | cut -f1) + ${EXTRA_SIZE_MB} ))

sudo mkfs.ext4 -d ${TARGET_ROOTFS_DIR} ${ROOTFSIMAGE} ${IMAGE_SIZE_MB}M

echo Rootfs Image: ${ROOTFSIMAGE}
