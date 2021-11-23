variable "user_password" {
  type    = string
  default = "powder!"
}

variable "user_username" {
  type    = string
  default = "ubuntu"
}

variable "cpu_arch" {
  type    = string
  default = "amd64"
}

variable "uefi_secureBoot" {
  type = string
  default = "TRUE"
}

variable "os_version" {
  type    = string
  default = "20.04.3"
}

variable "os_codename" {
  type    = string
  default = "focal"
}

variable "guest_os_type" {
  type = string
  default = "ubuntu-64"
}

variable "cpu_count" {
  type    = string
  default = "6"
}

variable "fusion_app_path" {
  type    = string
  default = "/Applications/VMware Fusion.app"
}

variable "ram_gb" {
  type    = string
  default = "16"
}

variable "disk_gb" {
  type    = string
  default = "30"
}

variable "ssh_key" {
  type    = string
  default = "nachos3"
}


source "vmware-iso" "ubuntu_amd64" {
  display_name = "{{build_name}} ${var.os_version}"
  vm_name      = "{{build_name}}_${var.os_version}"
  vmdk_name    = "{{build_name}}_${var.os_version}"
  fusion_app_path = var.fusion_app_path
  http_content = {
    "/meta-data" = ""
    "/user-data" = templatefile("${path.root}/files/user-data.pkrtpl", { ssh_key = var.ssh_key })
  }
  boot_command = [
    "<enter>",
    "c",
    "linux /casper/vmlinuz quiet autoinstall ds=nocloud-net\\;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<enter>",
    "initrd /casper/initrd <enter>", "boot<enter>"
  ]
  boot_key_interval = "4ms"
  boot_wait         = "4s"
  cpus              = var.cpu_count
  cores             = var.cpu_count
  memory            = var.ram_gb * 1024
  disk_adapter_type = "nvme"
  disk_size         = var.disk_gb * 1024
  disk_type_id      = "0"
  guest_os_type     = var.guest_os_type
  headless          = false
  skip_compaction   = true
  iso_checksum      = "file:https://cdimage.ubuntu.com/ubuntu-server/${var.os_codename}/daily-live/current/SHA256SUMS"
  iso_url           = "https://cdimage.ubuntu.com/ubuntu-server/${var.os_codename}/daily-live/current/${var.os_codename}-live-server-${var.cpu_arch}.iso"
  output_directory  = "output/{{build_name}}_${var.os_version}"
  shutdown_command  = "sudo shutdown -P now"
  shutdown_timeout  = "5m"
  ssh_password      = "${var.user_password}"
  ssh_timeout       = "10m"
  ssh_username      = "${var.user_username}"
  version           = "19"
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
    "bios.bootDelay" = "0000"
    # remove optical drives
    "sata0:0.autodetect"     = "TRUE"
    "sata0:0.deviceType"     = "cdrom-raw"
    "sata0:0.fileName"       = "auto detect"
    "sata0:0.startConnected" = "FALSE"
    "sata0:0.present"        = "TRUE"
  }
}

# arm64 source
source "vmware-iso" "ubuntu_arm64" {
  display_name = "{{build_name}} ${var.os_version}"
  vm_name      = "{{build_name}}_${var.os_version}"
  vmdk_name    = "{{build_name}}_${var.os_version}"
  fusion_app_path = var.fusion_app_path
  http_content = {
    "/meta-data" = ""
    "/user-data" = templatefile("${path.root}/files/user-data.pkrtpl", { ssh_key = var.ssh_key })
  }
  boot_command = [
    "<enter>",
    "c",
    "linux /casper/vmlinuz quiet autoinstall ds=nocloud-net\\;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<enter>",
    "initrd /casper/initrd <enter>", "boot<enter>"
  ]
  boot_key_interval = "4ms"
  boot_wait         = "4s"
  cpus              = var.cpu_count
  cores             = var.cpu_count
  memory            = var.ram_gb * 1024
  disk_adapter_type = "nvme"
  disk_size         = var.disk_gb * 1024
  disk_type_id      = "0"
  guest_os_type     = "arm-ubuntu-64"
  headless          = false
  skip_compaction   = true
  iso_checksum      = "file:https://cdimage.ubuntu.com/ubuntu-server/${var.os_codename}/daily-live/current/SHA256SUMS"
  iso_url           = "https://cdimage.ubuntu.com/ubuntu-server/${var.os_codename}/daily-live/current/${var.os_codename}-live-server-${var.cpu_arch}.iso"
  output_directory  = "output/{{build_name}}_${var.os_version}"
  shutdown_command  = "sudo shutdown -P now"
  shutdown_timeout  = "5m"
  ssh_password      = "${var.user_password}"
  ssh_timeout       = "10m"
  ssh_username      = "${var.user_username}"
  version           = "19"
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
    "uefi.secureBoot.enabled"        = "FALSE"
    "vhv.enable"                     = "TRUE"
    "virtualhw.productcompatibility" = "hosted"
    "vmx.allowNested"                = "TRUE"
    "vmx.buildType"                  = "release"
    "usb_xhci:4.deviceType" = "hid"
    "usb_xhci:4.parent" = "-1"
    "usb_xhci:4.port" = "4"
    "usb_xhci:4.present" = "TRUE"
    "usb_xhci:6.deviceType" = "hub"
    "usb_xhci:6.parent" = "-1"
    "usb_xhci:6.port" = "6"
    "usb_xhci:6.present" = "TRUE"
    "usb_xhci:6.speed" = "2"
    "usb_xhci:7.deviceType" = "hub"
    "usb_xhci:7.parent" = "-1"
    "usb_xhci:7.port" = "7"
    "usb_xhci:7.present" = "TRUE"
    "usb_xhci:7.speed" = "4"
    "usb_xhci.pciSlotNumber" = "192"
    "usb_xhci.present" = "TRUE"
  }
  vmx_data_post = {
    "bios.bootDelay" = "0000"
    # remove optical drives
    "sata0:0.autodetect"     = "TRUE"
    "sata0:0.deviceType"     = "cdrom-raw"
    "sata0:0.fileName"       = "auto detect"
    "sata0:0.startConnected" = "FALSE"
    "sata0:0.present"        = "TRUE"
  }
}



# amd64 buld
build {
  sources = ["source.vmware-iso.ubuntu_amd64"]
  provisioner "file" {
    sources     = ["files/config.json"]
    destination = "~/"
  }

  provisioner "shell" {
    environment_vars = [
      "CONFIG_VM=1"
    ]
    scripts = [
      "scripts/configure.sh"
    ]
  }
}

# arm64 buld
build {
  sources = ["source.vmware-iso.ubuntu_arm64"]
  provisioner "file" {
    sources     = ["files/config.json"]
    destination = "~/"
  }

  provisioner "shell" {
    environment_vars = [
      "CONFIG_VM=1"
    ]
    scripts = [
      "scripts/configure.sh"
    ]
  }
}
