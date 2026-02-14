# packer-ubuntu

Packer template that builds Ubuntu (default 25.10) for **amd64** with VMware Fusion on macOS.

## Prerequisites

- macOS with VMware Fusion
- [Packer](https://www.packer.io/) >= 1.7.0

## Building

1. **Optional:** override build variables by copying the example and editing:

   ```bash
   cp ubuntu.auto.EXAMPLE.hcl ubuntu.auto.pkrvars.hcl
   ```

   Edit `ubuntu.auto.pkrvars.hcl` (password hash, `ssh_key`, `hostname`, `fusion_app_path`, etc.). Generate a password hash with:

   ```bash
   openssl passwd -6 -salt $(openssl rand -hex 4) 'yourpassword'
   ```

2. **Build:**

   ```bash
   make
   ```

   Or without the Makefile:

   ```bash
   packer init .
   packer build .
   ```

   With a var file:

   ```bash
   packer build -var-file=ubuntu.auto.pkrvars.hcl .
   ```

3. **Output:** VM is in `output/vmware-iso_25.10/` (path depends on `os_version`).

## Cleanup

Stop the VM (if running) and remove the build output:

```bash
make clean
```

## What the build does

- **Cloud-init** (`files/user-data.pkrtpl`): user, hostname, SSH key, password.
- **Provisioning** (`scripts/configure.sh`): installs open-vm-tools, then [chezmoi](https://www.chezmoi.io/) with the `trodemaster` config, then cleanup.

Other config (dotfiles, packages) comes from the chezmoi setup, not from this repo.
