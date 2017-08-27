#!/bin/bash

set -xe

function mount_filesystems {
    mount --bind /dev $1/dev
    mount --bind /proc $1/proc
    mount --bind /sys $1/sys
}

function unmount_filesystems {
    umount $1/sys
    umount $1/proc
    umount $1/dev
}

mount_filesystems
trap unmount_filesystems EXIT

chroot $1 $2
