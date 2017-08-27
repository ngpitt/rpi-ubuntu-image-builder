#!/bin/bash

set -xe

apt update
apt install -y \
  debootstrap \
  qemu-user-static

rm -rf rootfs
rm -rf staging-files
mkdir -p rootfs
mkdir -p staging-files

qemu-debootstrap --arch=armhf zesty rootfs

cp -a files/* staging-files/
chown -R root:root staging-files/
cp -a staging-files/* rootfs/
cp /etc/resolv.conf rootfs/etc/

cp build-chroot.sh rootfs/
./chroot.sh rootfs "./build-chroot.sh"
rm rootfs/build-chroot.sh
