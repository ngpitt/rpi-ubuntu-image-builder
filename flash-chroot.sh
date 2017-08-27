#!/bin/bash

set -xe

sed -i "s/hostname/$1/g" /etc/hostname /etc/hosts

adduser $2
usermod -a -G sudo $2

dpkg-reconfigure openssh-server
