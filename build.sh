#!/bin/bash

set -xe

rm -rf rootfs
cp -a files rootfs
chown -R root:root rootfs/

qemu-debootstrap --arch=armhf zesty rootfs

cp /etc/resolv.conf rootfs/etc/resolv.conf

mount --bind /dev rootfs/dev
mount --bind /proc rootfs/proc
mount --bind /sys rootfs/sys

chroot rootfs /bin/bash < build-chroot.sh

umount rootfs/sys
umount rootfs/proc
umount rootfs/dev
