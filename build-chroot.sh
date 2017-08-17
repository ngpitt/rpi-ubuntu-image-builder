#!/bin/bash

set -xe

locale-gen en_US.UTF-8

apt-get update
apt-get upgrade -y
apt-get install -y \
  apt-transport-https \
  curl

curl https://packagecloud.io/gpg.key | apt-key add -
echo "deb https://packagecloud.io/Hypriot/rpi/debian/ jessie main
deb https://packagecloud.io/Hypriot/Schatzkiste/debian/ jessie main" > /etc/apt/sources.list.d/hypriot.list

curl http://archive.raspberrypi.org/debian/raspberrypi.gpg.key | apt-key add -
echo "deb http://archive.raspberrypi.org/debian/ jessie main" > /etc/apt/sources.list.d/raspberrypi.list

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y \
  --no-install-recommends \
  firmware-atheros \
  firmware-brcm80211 \
  firmware-libertas \
  firmware-ralink \
  firmware-realtek \
  raspberrypi-kernel \
  raspberrypi-bootloader \
  libraspberrypi0 \
  libraspberrypi-dev \
  libraspberrypi-bin \
  fake-hwclock \
  wpasupplicant \
  wireless-tools \
  ethtool \
  crda \
  bluetooth \
  pi-bluetooth

apt-get install -y \
  docker.io \
  kubeadm \
  htop \
  iotop \
  iftop \
  vim \
  ntp \
  net-tools \
  openssh-server \
  bash-completion \
  haveged \
  ubuntu-release-upgrader-core \
  unattended-upgrades

curl https://raw.githubusercontent.com/lurch/rpi-serial-console/master/rpi-serial-console -o /usr/local/bin/rpi-serial-console
chmod +x /usr/local/bin/rpi-serial-console

systemctl disable syslog
systemctl disable motd-news.service
systemctl disable motd-news.timer
systemctl enable docker
systemctl enable haveged
systemctl enable ntp

sed -i "s/    HashKnownHosts yes/#   HashKnownHosts yes/g" /etc/ssh/ssh_config
echo "
auto lo
iface lo inet loopback

allow-hotplug eth0
iface eth0 inet dhcp
" >> /etc/network/interfaces
echo "btrfs" >> /etc/initramfs-tools/modules
update-initramfs -c -k $(uname -r)

rm /etc/update-motd.d/10-help-text
rm /etc/update-motd.d/50-motd-news
rm /etc/ssh/ssh_host_*
rm /lib/systemd/system/motd*

dpkg-reconfigure tzdata
dpkg-reconfigure resolvconf

apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
