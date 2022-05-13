#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
shopt -s nullglob nocaseglob

# modern bash version check
! [ "${BASH_VERSINFO:-0}" -ge 4 ] && echo "This script requires bash v4 or later" && exit 1

sudo qemu-system-aarch64 \
  -display cocoa,show-cursor=on \
  -accel hvf \
  -accel tcg,tb-size=1024 \
  -m 4096 \
  -cpu max \
  -smp cpus=4,sockets=1,cores=4,threads=1 \
  -M virt,highmem=off \
  -device virtio-rng-pci \
  -drive if=pflash,format=raw,unit=1,file=files/RELEASEAARCH64_QEMU_VARS.fd,readonly=on \
  -drive if=pflash,format=raw,unit=0,file=files/RELEASEAARCH64_QEMU_EFI.fd,readonly=on \
  -drive if=none,file=output/ubuntu_22.04/ubuntu_22.04.qcow2,format=qcow2,id=hd0 \
  -device virtio-blk-device,drive=hd0,serial="dummyserial" \
  -device virtio-net-pci,mac=06:6D:A1:46:DF:05,netdev=net0 \
  -netdev vmnet-shared,id=net0 \
  -device nec-usb-xhci,id=usb-bus \
  -device usb-tablet,bus=usb-bus.0 \
  -device usb-mouse,bus=usb-bus.0 \
  -device usb-kbd,bus=usb-bus.0 \
  -device qemu-xhci,id=usb-controller-0 \
  -device virtio-gpu-pci \
  -monitor stdio

exit 0

enp0s2