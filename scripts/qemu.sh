#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
shopt -s nullglob nocaseglob

# modern bash version check
! [ "${BASH_VERSINFO:-0}" -ge 4 ] && echo "This script requires bash v4 or later" && exit 1

# path to self and parent dir
SCRIPT=$(realpath $0)
SCRIPTPATH=$(dirname $SCRIPT)

sudo tee /etc/netplan/01-virtio-net-pci.yaml > /dev/null <<-'ENP0S2'
network:
  ethernets:
    enp0s2:
      dhcp4: true
      dhcp-identifier: mac
  version: 2
ENP0S2