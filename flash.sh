#!/bin/bash

set -xe

rm -rf staging-bootfs
rm -rf staging-rootfs
mkdir -p staging-bootfs
mkdir -p staging-rootfs

cp -a rootfs/* staging-rootfs/
mv staging-rootfs/boot/* staging-bootfs/

sed -i "s/hostname/$1/g" staging-rootfs/etc/hostname staging-rootfs/etc/hosts

mount --bind /dev staging-rootfs/dev
mount --bind /proc staging-rootfs/proc
mount --bind /sys staging-rootfs/sys

chroot staging-rootfs /bin/bash -c "set -xe;
adduser $2;
usermod -a -G sudo $2;
dpkg-reconfigure openssh-server"

umount staging-rootfs/sys
umount staging-rootfs/proc
umount staging-rootfs/dev

rm staging-rootfs/usr/bin/qemu-arm-static

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
