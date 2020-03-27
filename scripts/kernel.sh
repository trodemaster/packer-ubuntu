#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
shopt -s nullglob
shopt -s nocaseglob

kernel.panic = 20 >> /etc/sysctl.conf

apt-cache search linux-image-5.0.0 | grep generic

sudo apt install --install-recommends linux-generic-hwe-18.04
sudo apt install --install-recommends linux-image-5.0.0-41-generic linux-headers-5.0.0-41-generic linux-modules-5.0.0-41-generic linux-modules-extra-5.0.0-41-generic linux-tools-5.0.0-41-generic
linux-modules-5.0.0-41

5.4.10

uname -r
sudo apt-mark hold 4.10.0-27-generic

wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.4.10/linux-headers-5.4.10-050410-generic_5.4.10-050410.202001091038_amd64.deb
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.4.10/linux-image-unsigned-5.4.10-050410-generic_5.4.10-050410.202001091038_amd64.deb
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.4.10/linux-modules-5.4.10-050410-generic_5.4.10-050410.202001091038_amd64.deb


https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.5-rc6/linux-headers-5.5.0-050500rc6_5.5.0-050500rc6.202001122031_all.deb
https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.5-rc6/linux-headers-5.5.0-050500rc6-generic_5.5.0-050500rc6.202001122031_amd64.deb
https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.5-rc6/linux-image-unsigned-5.5.0-050500rc6-generic_5.5.0-050500rc6.202001122031_amd64.deb
https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.5-rc6/linux-modules-5.5.0-050500rc6-generic_5.5.0-050500rc6.202001122031_amd64.deb


sudo apt remove $(dpkg --get-selections | grep 5.2.21 | cut -f 1 | tr '\r\n' ' ')

wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.4.1/linux-headers-5.4.1-050401_5.4.1-050401.201911290555_all.deb
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.4.1/linux-headers-5.4.1-050401-generic_5.4.1-050401.201911290555_amd64.deb
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.4.1/linux-image-unsigned-5.4.1-050401-generic_5.4.1-050401.201911290555_amd64.deb
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.4.1/linux-modules-5.4.1-050401-generic_5.4.1-050401.201911290555_amd64.deb

wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.2.21/linux-headers-5.2.21-050221_5.2.21-050221.201910111731_all.deb
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.2.21/linux-headers-5.2.21-050221-generic_5.2.21-050221.201910111731_amd64.deb
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.2.21/linux-image-unsigned-5.2.21-050221-generic_5.2.21-050221.201910111731_amd64.deb
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.2.21/linux-modules-5.2.21-050221-generic_5.2.21-050221.201910111731_amd64.deb
