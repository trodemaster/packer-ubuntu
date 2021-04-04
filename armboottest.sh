qemu-system-aarch64 -machine virt,highmem=off \
  -accel hvf \
  -cpu cortex-a72 \
  -smp 2 \
  -m 4096 \
  -bios iso/QEMU_EFI.fd \
  -device virtio-gpu-pci \
  -drive if=virtio,format=qcow2,file=ubuntu.qcow2 \
  -device virtio-scsi-pci,id=scsi0 \
  -object rng-random,filename=/dev/urandom,id=rng0 \
  -device virtio-rng-pci,rng=rng0 \
  -device virtio-net-pci,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp::8022-:22 \
  -display default,show-cursor=on \
  -vga std \
  -drive if=virtio,format=raw,file=iso/ubuntu-20.04.2-live-server-arm64.iso \
  -device qemu-xhci \
  -device usb-kbd \
  -device usb-tablet \
  -device intel-hda \
  -device hda-duplex

exit 0

./qemu-system-aarch64 \
  -monitor stdio \
  -M virt,highmem=off \
  -accel hvf \
  -cpu cortex-a72 \
  -smp 4 \
  -m 4096 \
  -drive file=~/Downloads/pflash0.img,format=raw,if=pflash,readonly=on \
  -drive file=~/Downloads/pflash1.img,format=raw,if=pflash \
  -device virtio-gpu-pci \
  -display default,show-cursor=on \
  -device qemu-xhci \
  -device usb-kbd \
  -device usb-tablet \
  -device intel-hda \
  -device hda-duplex \
  -drive file=~/Downloads/ubuntu.qcow2,if=virtio,cache=writethrough \
  -cdrom ~/Downloads/ubuntu-20.04.1-live-server-arm64.iso

none                 no graphic card
std                  standard VGA
cirrus               Cirrus VGA (default)
vmware               VMWare SVGA
xenfb                Xen paravirtualized framebuffer

console=ttyS0,115200
# -nographic

# https://gist.github.com/niw/e4313b9c14e968764a52375da41b4278