# This file was autogenerate by the BETA 'packer hcl2_upgrade' command. We
# recommend double checking that everything is correct before going forward. We
# also recommend treating this file as disposable. The HCL2 blocks in this
# file can be moved to other files. For example, the variable blocks could be
# moved to their own 'variables.pkr.hcl' file, etc. Those files need to be
# suffixed with '.pkr.hcl' to be visible to Packer. To use multiple files at
# once they also need to be in the same folder. 'packer inspect folder/'
# will describe to you what is in that folder.

# All generated input variables will be of string type as this how Packer JSON
# views them; you can later on change their type. Read the variables type
# constraints documentation
# https://www.packer.io/docs/from-1.5/variables#type-constraints for more info.
variable "iso_file_checksum_x64" {
  type    = string
  default = "sha256:443511f6bf12402c12503733059269a2e10dec602916c0a75263e5d990f6bb93"
}

variable "iso_filename_x64" {
  type    = string
  default = "ubuntu-20.04.1-live-server-amd64.iso"
}

variable "iso_file_checksum_arm" {
  type    = string
  default = "sha256:443511f6bf12402c12503733059269a2e10dec602916c0a75263e5d990f6bb93"
}

variable "iso_filename_arm" {
  type    = string
  default = "ubuntu-20.04.1-live-server-arm64.iso"
}

variable "user_password" {
  type    = string
  default = "Ubuntu20!"
}

variable "user_username" {
  type    = string
  default = "ubuntu"
}

# "timestamp" template function replacement
#locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors onto a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/from-1.5/blocks/source

source "vmware-iso" "base" {
  boot_command = [
    "<enter>",
    "c",
    "linux /casper/vmlinuz quiet autoinstall ds=nocloud-net\\;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<enter>",
    "initrd /casper/initrd <enter>",
    "boot<enter>"
  ]
  boot_key_interval    = "4ms"
  boot_wait            = "4s"
  cores                = "6"
  cpus                 = "6"
  disk_adapter_type    = "pvscsi"
  disk_size            = "102400"
  disk_type_id         = "0"
  guest_os_type        = "ubuntu-64"
  headless             = false
  http_directory       = "http"
  iso_checksum         = "${var.iso_file_checksum}"
  iso_url              = "iso/${var.iso_filename}"
  memory               = "16144"
  network_adapter_type = "vmxnet3"
  output_directory     = "vm/Ubuntu_20.04_base"
  shutdown_command     = "sudo shutdown -P now"
  shutdown_timeout     = "5m"
  ssh_password         = "${var.user_password}"
  ssh_timeout          = "10m"
  ssh_username         = "${var.user_username}"
  version              = "18"
  display_name         = "Ubuntu 20.04 base"
  vm_name              = "Ubuntu_20.04_base"
  vmdk_name            = "Ubuntu_20.04_base"
  vmx_data = {
    "bios.bootDelay"                 = "4000"
    firmware                         = "efi"
    "powerType.powerOff"             = "hard"
    "powerType.powerOn"              = "hard"
    "powerType.reset"                = "hard"
    "powerType.suspend"              = "hard"
    "time.synchronize.continue"      = "1"
    "time.synchronize.restore"       = "1"
    "time.synchronize.resume.disk"   = "1"
    "time.synchronize.resume.host"   = "1"
    "time.synchronize.shrink"        = "1"
    "time.synchronize.tools.enable"  = "1"
    "time.synchronize.tools.startup" = "1"
    "tools.upgrade.policy"           = "manual"
    "uefi.secureBoot.enabled"        = "TRUE"
    "vhv.enable"                     = "TRUE"
    "virtualhw.productcompatibility" = "hosted"
    "vmx.allowNested"                = "TRUE"
    "vmx.buildType"                  = "release"
  }
  vmx_data_post = {
    "bios.bootDelay"                 = "0000"
    "ide1:0.deviceType"              = "atapi-cdrom"
    "ide1:0.fileName"                = "cdrom0"
    "ide1:0.present"                 = "TRUE"
    "ide1:0.startConnected"          = "FALSE"
    "time.synchronize.continue"      = "1"
    "time.synchronize.restore"       = "1"
    "time.synchronize.resume.disk"   = "1"
    "time.synchronize.resume.host"   = "1"
    "time.synchronize.shrink"        = "1"
    "time.synchronize.tools.enable"  = "1"
    "time.synchronize.tools.startup" = "1"
    "tools.syncTime"                 = "0"
  }
  vnc_disable_password = "true"
}

source "vmware-iso" "full" {
  boot_command      = [
    "<enter>",
    "c",
    "linux /casper/vmlinuz quiet autoinstall ds=nocloud-net\\;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<enter>",
    "initrd /casper/initrd <enter>", "boot<enter>"
    ]
  boot_key_interval = "4ms"
  boot_wait         = "4s"
  cores             = "6"
  cpus              = "6"
  disk_adapter_type = "pvscsi"
  disk_size         = "102400"
  disk_type_id      = "0"
  guest_os_type     = "ubuntu-64"
  headless          = false
  http_directory    = "http"
  iso_checksum      = "${var.iso_file_checksum}"
  iso_url           = "iso/${var.iso_filename}"
  memory            = "16144"
  output_directory  = "vm/Ubuntu_20.04"
  shutdown_command  = "sudo shutdown -P now"
  shutdown_timeout  = "5m"
  ssh_password      = "${var.user_password}"
  ssh_timeout       = "10m"
  ssh_username      = "${var.user_username}"
  version           = "18"
  display_name         = "Ubuntu 20.04"
  vm_name              = "Ubuntu_20.04"
  vmdk_name            = "Ubuntu_20.04"
    vmx_data = {
    "bios.bootDelay"                 = "4000"
    "ethernet0.virtualdev"           = "vmxnet3"
    firmware                         = "efi"
    "powerType.powerOff"             = "hard"
    "powerType.powerOn"              = "hard"
    "powerType.reset"                = "hard"
    "powerType.suspend"              = "hard"
    "time.synchronize.continue"      = "1"
    "time.synchronize.restore"       = "1"
    "time.synchronize.resume.disk"   = "1"
    "time.synchronize.resume.host"   = "1"
    "time.synchronize.shrink"        = "1"
    "time.synchronize.tools.enable"  = "1"
    "time.synchronize.tools.startup" = "1"
    "tools.upgrade.policy"           = "manual"
    "uefi.secureBoot.enabled"        = "TRUE"
    "vhv.enable"                     = "TRUE"
    "virtualhw.productcompatibility" = "hosted"
    "vmx.allowNested"                = "TRUE"
    "vmx.buildType"                  = "release"
  }
  vmx_data_post = {
    "bios.bootDelay"                 = "0000"
    "ide1:0.deviceType"     = "atapi-cdrom"
    "ide1:0.fileName"       = "cdrom0"
    "ide1:0.present"        = "TRUE"
    "ide1:0.startConnected" = "FALSE"
  }
}

source "vmware-vmx" "customize" {
  display_name         = "Ubuntu 20.04 customize"
  vm_name              = "Ubuntu_20.04_customize"
  vmdk_name            = "Ubuntu_20.04_customize"
  headless         = false
  http_directory   = "http"
  output_directory = "vm/Ubuntu_20.04_customize"
  shutdown_command = "sudo shutdown -P now"
  skip_compaction  = "true"
  source_path      = "vm/Ubuntu_20.04_base/Ubuntu_20.04_base.vmx"
  ssh_password     = "${var.user_password}"
  ssh_username     = "${var.user_username}"
    vmx_data_post = {
    "ide1:0.deviceType"     = "atapi-cdrom"
    "ide1:0.fileName"       = "cdrom0"
    "ide1:0.present"        = "TRUE"
    "ide1:0.startConnected" = "FALSE"
  }
}

source "qemu" "base" {
  iso_checksum      = "${var.iso_file_checksum_arm}"
  iso_url           = "iso/${var.iso_filename_arm}"
  output_directory  = "vm"
  shutdown_command  = "echo 'packer' | sudo -S shutdown -P now"
  disk_size         = 1024 * 32
  format            = "qcow2"
  memory = 1024 * 4
  accelerator       = "hvf"
  http_directory    = "http"
  ssh_password     = "${var.user_password}"
  ssh_username     = "${var.user_username}"
  ssh_timeout       = "20m"
  vm_name           = "ubuntu.qcow2"
  net_device        = "virtio-net"
  disk_interface    = "virtio"
  boot_wait         = "1s"
  qemu_binary = "qemu-system-aarch64"
  qemuargs = [ 
                [ "-monitor", "stdio" ],
                [ "-drive" , "file=iso/pflash0.img,format=raw,if=pflash,readonly=on,id=pflash0" ],
#                [ "-drive" , "file=iso/pflash1.img,format=raw,if=pflash,id=pflash1" ],
                [ "-drive", "file=vm/ubuntu.qcow2,if=virtio,cache=unsafe,format=qcow2,id=disk0" ],
                [ "-drive", "if=virtio,format=raw,file=iso/ubuntu-20.04.2-live-server-arm64.iso,readonly=on,id=cdrom0" ],
                [ "-machine", "virt,highmem=off,accel=hvf"],
                [ "-device", "virtio-gpu-pci" ],
                [ "-cpu", "max" ],
                [ "-smp", "2" ],
                [ "-vga", "std" ],
                [ "-m", "4096" ],
                [ "-device", "qemu-xhci" ],
                [ "-device", "usb-kbd" ],
                [ "-device", "usb-tablet" ],
                [ "-device", "intel-hda" ],
                [ "-device", "hda-duplex" ],
                [ "-object", "rng-random,filename=/dev/urandom,id=rng0" ],
                [ "-device", "virtio-rng-pci,rng=rng0" ],
                [ "-device", "virtio-scsi-pci,id=scsi0" ],
                [ "-boot", "strict=off" ]
              ]
  machine_type = "virt"
  display = "cocoa,show-cursor=on"
  boot_command      = [
"<wait5>",
    "c", # enter grub and send boot commands next
    "<wait5>",
    "linux /casper/vmlinuz quiet autoinstall ds=nocloud-net\\;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<enter>",
    "initrd /casper/initrd <enter>", "boot<enter>"
    ]
}




build {
  sources = ["source.qemu.base"]
  provisioner "shell" {
    scripts = [
    "scripts/ubuntu.sh",
    "scripts/devtools.sh",
    "scripts/minimize.sh"
    ]
}
}

build {
  name = "base"
  sources = ["source.vmware-iso.base"]
  provisioner "shell" {
    script = "scripts/tools-ubuntu-openvm.sh"
  }
}

build {
  name = "customize"
  sources = ["source.vmware-vmx.customize"]
  provisioner "shell" {
    scripts = [
      "scripts/ubuntu.sh",
      "scripts/devtools.sh"
    ]
  }
}

build {
  name = "full"
  sources = ["source.vmware-iso.full"]
  provisioner "shell" {
    scripts = [
    "scripts/tools-ubuntu-openvm.sh",
    "scripts/ubuntu.sh",
    "scripts/devtools.sh",
    "scripts/minimize.sh"
    ]
  }
}
