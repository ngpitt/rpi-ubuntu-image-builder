#!/bin/bash

set -xe

function mount_filesystems {
    mount --bind /dev rootfs/dev
    mount --bind /proc rootfs/proc
    mount --bind /sys rootfs/sys
}

function unmount_filesystems {
    umount rootfs/sys
    umount rootfs/proc
    umount rootfs/dev
}

mount_filesystems
trap unmount_filesystems EXIT

chroot rootfs
