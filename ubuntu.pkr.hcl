variable "user_password" {
  type    = string
  default = "ubuntu"
}

variable "user_password_hash" {
  type    = string
  default = "$6$MfDK0nZgfqn7r48w$34F7qOuYtOyZTSb20iFvhdmSYI/GnExPcY.dWjl.ROIMjkz1/eh4KpbvlA8fBkFVEFHMFqJJAVB3fnnXvmUtv/"
}

variable "user_username" {
  type    = string
  default = "ubuntu"
}

variable "hostname" {
  type    = string
  default = "ubuntu"
}

variable "docker_imagename" {
  type    = string
  default = "devctnr"
}

variable "cpu_arch" {
  type    = string
  default = "amd64"
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

variable "apt_repo" {
  type = string
  default = "0"
}

variable "docker_login_username" {
  type = string
  default = "packer"
}

variable "docker_login_password" {
  type = string
  default = "packer"
}

variable "docker_login_server" {
  type = string
  default = "docker.io"
}

variable "iso_url" {
  type = string
  default = "https://cdimage.ubuntu.com/cdimage/ubuntu-server/jammy/daily-live/pending/jammy-live-server-arm64.iso"
}

variable "iso_checksum" {
  type = string
  default = "file:https://cdimage.ubuntu.com/cdimage/ubuntu-server/jammy/daily-live/pending/SHA256SUMS"
}

variable "headless" {
  type = bool
  default = true
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
    "<wait>",
    "<enter>",
    "c",
    "<wait5s>",
    "linux /casper/vmlinuz quiet autoinstall ds=nocloud-net\\;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<enter>",
    "initrd /casper/initrd <enter>",
    "boot<enter>",
    "<wait180s>"
  ]
  boot_key_interval = "5ms"
  boot_wait         = "5s"
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
    "ethernet0.virtualdev"           = "e1000e"
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

source "qemu" "ubuntu" {
  iso_checksum      = "file:https://cdimage.ubuntu.com/releases/${var.os_version}/release/SHA256SUMS"
  iso_url           = "https://cdimage.ubuntu.com/releases/${var.os_version}/release/ubuntu-${var.os_version}-live-server-arm64.iso"
  output_directory  = "output/{{build_name}}_${var.os_version}"
  shutdown_command  = "sudo shutdown -P now"
  shutdown_timeout  = "5m"
  disk_size         = var.disk_gb * 1024
  memory = var.ram_gb * 1024
  format            = "qcow2"
  accelerator       = "hvf"
  ssh_password      = var.user_password
  ssh_timeout       = "10m"
  ssh_username      = var.user_username
  vm_name         = "{{build_name}}_${var.os_version}.qcow2"
  net_device        = "virtio-net"
  disk_interface    = "virtio"
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
    "<wait2>",
    "<e>",
    "<f2>",
    "<enter>",
    "<wait>",
    "set gfxpayload=keep <enter>",
    "linux /casper/vmlinuz quiet autoinstall ds=nocloud-net\\;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<enter>",
    "initrd /casper/initrd <enter>",
    "boot<enter>",
    "<wait200s>"
  ]
  boot_key_interval = "5ms"
  boot_wait         = "5s"
  firmware = "files/RELEASEAARCH64_QEMU_EFI.fd"
  qemu_binary = "qemu-system-aarch64"
  qemuargs = [
  [ "-nodefaults" ],
  [ "-vga", "none" ],
  [ "-display", "cocoa,show-cursor=on"],
  [ "-device", "virtio-rng-pci" ],
  [ "-cpu", "host" ],
  [ "-smp", "cpus=8,sockets=1,cores=8,threads=1" ],
  [ "-machine", "virt,highmem=off" ],
  [ "-accel", "hvf" ],
  [ "-accel", "tcg,tb-size=8192" ],
  [ "-boot", "menu=on" ],
  [ "-netdev", "user,hostfwd=tcp::{{ .SSHHostPort }}-:22,id=forward"], 
  [ "-device", "virtio-net-device,netdev=forward,id=net0"],
  [ "-device", "usb-ehci" ],
  [ "-device", "usb-kbd" ], 
  [ "-device", "usb-mouse" ],
  [ "-device", "virtio-gpu-pci" ]

]
}

build {
  sources = ["source.qemu.ubuntu"]
    provisioner "file" {
    sources     = ["files/config.json"]
    destination = "/tmp/"
  }

  provisioner "shell" {
    environment_vars = [
      "CONFIG_VM=1",
      "APT_REPO=${var.apt_repo}"
    ]
    scripts = [
      "scripts/configure.sh",
      "scripts/qemu.sh"
    ]
  }
}




source "docker" "ubuntu" {
  image = "ubuntu"
  commit = true
  changes = [
    "ENTRYPOINT [\"/usr/bin/dumb-init\", \"--\"]",
    "CMD /usr/local/bin/sshd && exec /usr/sbin/sshd",
    "ENV TERM xterm-256color",
    "ENV TZ America/Los_Angeles",
    "ENV DEBIAN_FRONTEND noninteractive",
    "EXPOSE 443 22"
  ]
}

build {
  name    = "remote"
  sources = ["source.docker.ubuntu"]

  provisioner "file" {
    sources     = ["files/config.json", "files/sshd"]
    destination = "/tmp/"
  }

  provisioner "shell" {
    environment_vars = [
      "CONFIG_CONTAINER=1",
      "APT_REPO=${var.apt_repo}",
      "SSH_KEY=${var.ssh_key}"
    ]
    scripts = [
      "scripts/configure.sh"
    ]
  }

  post-processors {
    post-processor "docker-tag" {
      repository = join("", [var.docker_login_server, "/", var.docker_imagename])
      tags       = ["latest"]
    }
    post-processor "docker-push" {
      login          = true
      login_server   = var.docker_login_server
      login_username = var.docker_login_username
      login_password = var.docker_login_password
    }
  }
}

build {
  name    = "local"
  sources = ["source.docker.ubuntu"]

  provisioner "file" {
    sources     = ["files/config.json", "files/sshd"]
    destination = "/tmp/"
  }

  provisioner "shell" {
    environment_vars = [
      "CONFIG_CONTAINER=1",
      "APT_REPO=${var.apt_repo}",
      "SSH_KEY=${var.ssh_key}"
    ]
    scripts = [
      "scripts/configure.sh"
    ]
  }

    post-processor "docker-tag" {
      repository = var.docker_imagename
      tags       = [ "latest" ]
    }
}

# vmware-iso build
build {
  sources = ["source.vmware-iso.ubuntu"]
  provisioner "file" {
    sources     = ["files/config.json"]
    destination = "/tmp/"
  }

  provisioner "shell" {
    environment_vars = [
      "CONFIG_VM=1",
      "APT_REPO=${var.apt_repo}"
    ]
    scripts = [
      "scripts/configure.sh"
    ]
  }
}
