#!/bin/bash

set -xe

mount --bind /dev rootfs/dev
mount --bind /proc rootfs/proc
mount --bind /sys rootfs/sys

chroot rootfs

umount rootfs/sys
umount rootfs/proc
umount rootfs/dev
