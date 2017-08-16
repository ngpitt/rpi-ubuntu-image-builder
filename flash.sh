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

umount /dev/mmcblk0p1
umount /dev/mmcblk0p2

sfdisk /dev/mmcblk0 << EOF
,131072,c
,,83
EOF

mkfs.vfat /dev/mmcblk0p1
mkfs.ext4 /dev/mmcblk0p2

mount /dev/mmcblk0p1 /mnt
cp -a staging-bootfs/* /mnt/
umount /mnt

mount /dev/mmcblk0p2 /mnt
cp -a staging-rootfs/* /mnt/
umount /mnt
