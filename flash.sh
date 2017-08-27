#!/bin/bash

set -xe

apt update
apt install -y \
  dosfstools \
  btrfs-tools

rm -rf staging-bootfs
rm -rf staging-rootfs
mkdir -p staging-bootfs
mkdir -p staging-rootfs

cp -a rootfs/* staging-rootfs/

cp flash-chroot.sh staging-rootfs/
./chroot.sh staging-rootfs "./flash-chroot.sh $1 $2"
rm staging-rootfs/flash-chroot.sh
rm staging-rootfs/usr/bin/qemu-arm-static
mv staging-rootfs/boot/* staging-bootfs/

umount $3?* || /bin/true

sfdisk $3 << EOF
,131072,c
,,83
EOF
partprobe

BOOT_PART=$(fdisk -l $3 | grep ^$3 | awk '{print $1}' | sed -n 1p)
ROOT_PART=$(fdisk -l $3 | grep ^$3 | awk '{print $1}' | sed -n 2p)

mkfs.vfat $BOOT_PART
mkfs.btrfs -f $ROOT_PART

mount $BOOT_PART /mnt
cp -a staging-bootfs/* /mnt/
umount /mnt

mount $ROOT_PART /mnt
cp -a staging-rootfs/* /mnt/
umount /mnt
