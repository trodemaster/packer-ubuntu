packer {
  required_version = ">= 1.7.0"
  required_plugins {
    vmware = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/vmware"
    }
  }
}

variable "user_password" {
  type    = string
  default = "ubuntu"
}

variable "user_password_hash" {
  type    = string
  default = "$6$MfDK0nZgfqn7r48w$34F7qOuYtOyZTSb20iFvhdmSYI/GnExPcY.dWjl.ROIMjkz1/eh4KpbvlA8fBkFVEFHMFqJJAVB3fnnXvmUtv/" # hash of "ubuntu"
}

variable "user_username" {
  type    = string
  default = "ubuntu"
}

variable "boot_wait" {
  type = string
  default = "5s"
}

variable "hostname" {
  type    = string
  default = "ubuntu"
}

variable "os_version" {
  type    = string
  default = "25.10"
}

variable "guest_os_type" {
  type    = string
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
  default = ""
}

variable "iso_url" {
  type    = string
  default = "https://mirror.fcix.net/ubuntu-releases/25.10/ubuntu-25.10-live-server-amd64.iso"
}

variable "iso_checksum" {
  type    = string
  default = "file:https://mirror.fcix.net/ubuntu-releases/25.10/SHA256SUMS"
}

variable "headless" {
  type    = bool
  default = false
}

source "vmware-iso" "ubuntu" {
  display_name    = "{{build_name}} ${var.os_version}"
  vm_name         = "{{build_name}}_${var.os_version}"
  vmdk_name       = "{{build_name}}_${var.os_version}"
  fusion_app_path = var.fusion_app_path
  http_content = {
    "/meta-data" = ""
    "/user-data" = templatefile("${path.root}/files/user-data.pkrtpl", {
      ssh_key            = var.ssh_key
      hostname           = var.hostname
      user_username      = var.user_username
      user_password_hash = var.user_password_hash
    })
  }
  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;seedfrom=http://{{.HTTPIP}}:{{.HTTPPort}}/\"",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot",
    "<enter>",
    "<wait300>"
  ]
  boot_key_interval = "5ms"
  boot_wait         = var.boot_wait
  cpus              = var.cpu_count
  cores             = var.cpu_count
  memory            = var.ram_gb * 1024
  disk_adapter_type = "nvme"
  disk_size         = var.disk_gb * 1024
  disk_type_id      = "0"
  guest_os_type     = var.guest_os_type
  headless          = var.headless
  skip_compaction   = true
  iso_url = var.iso_url
  iso_checksum = var.iso_checksum
  output_directory  = "output/{{build_name}}_${var.os_version}"
  shutdown_command  = "sudo shutdown -P now"
  shutdown_timeout  = "5m"
  ssh_password      = var.user_password
  ssh_timeout       = "20m"
  ssh_username      = var.user_username
  version           = "20"
  vmx_data = {
    "bios.bootDelay"                 = "0500"
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
    "vhv.enable"                     = "FALSE"
    "virtualhw.productcompatibility" = "hosted"
    "vmx.allowNested"                = "FALSE"
    "vmx.buildType"                  = "release"
    "usb_xhci:4.deviceType"          = "hid"
    "usb_xhci:4.parent"              = "-1"
    "usb_xhci:4.port"                = "4"
    "usb_xhci:4.present"             = "TRUE"
    "usb_xhci:6.deviceType"          = "hub"
    "usb_xhci:6.parent"              = "-1"
    "usb_xhci:6.port"                = "6"
    "usb_xhci:6.present"             = "TRUE"
    "usb_xhci:6.speed"               = "2"
    "usb_xhci:7.deviceType"          = "hub"
    "usb_xhci:7.parent"              = "-1"
    "usb_xhci:7.port"                = "7"
    "usb_xhci:7.present"             = "TRUE"
    "usb_xhci:7.speed"               = "4"
    "usb_xhci.pciSlotNumber"         = "192"
    "usb_xhci.present"               = "TRUE"
    "ehci.present"                   = "FALSE"
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

build {
  name    = "vmware-iso"
  sources = ["source.vmware-iso.ubuntu"]

  provisioner "shell" {
    environment_vars = [
      "PACKER_USERNAME=${var.user_username}"
    ]
    scripts = ["scripts/configure.sh"]
  }
}
