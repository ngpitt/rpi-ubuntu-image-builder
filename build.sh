#!/bin/bash

set -xe

rm -rf rootfs
rm -rm staging-files
mkdir -p rootfs
mkdir -p staging-files

qemu-debootstrap --arch=armhf zesty rootfs

cp -a files/* staging-files/
chown -R root:root staging-files/
cp -a staging-files/* rootfs/
cp /etc/resolv.conf rootfs/etc/resolv.conf

mount --bind /dev rootfs/dev
mount --bind /proc rootfs/proc
mount --bind /sys rootfs/sys

chroot rootfs /bin/bash < build-chroot.sh

umount rootfs/sys
umount rootfs/proc
umount rootfs/dev
