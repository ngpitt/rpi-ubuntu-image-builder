#!/bin/bash

set -xe

rm -rf rootfs
mkdir -p rootfs

qemu-debootstrap --arch=armhf zesty rootfs

sudo chown -R root:root files/
cp -a files/* rootfs/

mount --bind /dev rootfs/dev
mount --bind /proc rootfs/proc
mount --bind /sys rootfs/sys

chroot rootfs /bin/bash < build-chroot.sh

umount rootfs/sys
umount rootfs/proc
umount rootfs/dev
