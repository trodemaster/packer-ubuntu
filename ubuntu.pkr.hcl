variable "user_password" {
  type    = string
  default = "powder!"
}

variable "user_username" {
  type    = string
  default = "ubuntu"
}

variable "cpu_arch" {
  type = string
  default = "amd64"
}

variable "os_version" {
  type = string
  default = "20.04.3"
}

variable "os_codename" {
  type = string
  default = "focal"
}

variable "cpu_count" {
  type = string
  default = "6"
}

variable "ram_gb" {
  type = string
  default = "16"
}

variable "disk_gb" {
  type = string
  default = "30"
}

# https://cdimage.ubuntu.com/ubuntu-server/focal/daily-live/current/focal-live-server-amd64.iso
# "https://cdimage.ubuntu.com/ubuntu-server/${var.os_codename}/daily-live/current/${var.os_codename}-live-server-${cpu_arch}.iso"
# https://cdimage.ubuntu.com/ubuntu-server/focal/daily-live/current/SHA256SUMS
# "https://cdimage.ubuntu.com/ubuntu-server/${var.os_codename}/daily-live/current/SHA256SUMS"

source "vmware-iso" "ubuntu" {
  display_name         = "{{build_name}} ${var.os_version}"
  vm_name              = "{{build_name}}_${var.os_version}"
  vmdk_name            = "{{build_name}}_${var.os_version}"  
  boot_command      = [
    "<enter>",
    "c",
    "linux /casper/vmlinuz quiet autoinstall ds=nocloud-net\\;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<enter>",
    "initrd /casper/initrd <enter>", "boot<enter>"
    ]
  boot_key_interval = "4ms"
  boot_wait         = "4s"
  cpus                 = var.cpu_count
  cores                = var.cpu_count
  memory               = var.ram_gb * 1024
  disk_adapter_type = "nvme"
  disk_size         = var.disk_gb * 1024
  disk_type_id      = "0"
  guest_os_type     = "ubuntu-64"
  headless          = false
  http_directory    = "http"
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
    "bios.bootDelay"                 = "0000"
    "ide1:0.deviceType"     = "atapi-cdrom"
    "ide1:0.fileName"       = "cdrom0"
    "ide1:0.present"        = "TRUE"
    "ide1:0.startConnected" = "FALSE"
  }
}

build {
#  name = "full"
  sources = ["source.vmware-iso.ubuntu"]
    provisioner "file" {
    sources     = ["files/config.json"]
    destination = "~/"
  }

  provisioner "shell" {
    scripts = [
    "scripts/configure.sh"
    ]
  }
}
