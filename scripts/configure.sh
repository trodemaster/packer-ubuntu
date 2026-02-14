#!/usr/bin/env bash
# Packer VM configure: open-vm-tools, chezmoi (early), cleanup.
# Other scripts in this dir are kept for reference.

set -euo pipefail

SCRIPT=$(realpath "${BASH_SOURCE[0]}")
SCRIPTPATH=$(dirname "$SCRIPT")

# Target user for chezmoi (set by Packer, default ubuntu)
TARGET_USER="${PACKER_USERNAME:-ubuntu}"
export DEBIAN_FRONTEND=noninteractive

# ---- 1. Open VM tools (early, for VMware Fusion) ----
install_open_vm_tools() {
  echo "==> Installing open-vm-tools..."
  sudo apt update -qq
  sudo apt install -y open-vm-tools
  if [[ -x /usr/bin/vmware-toolbox-cmd ]]; then
    echo "==> open-vm-tools version: $(/usr/bin/vmware-toolbox-cmd --version)"
  else
    echo "==> WARNING: vmware-toolbox-cmd not found after install"
  fi
}

# ---- 2. Chezmoi (early so it can replace later package/config steps) ----
install_chezmoi() {
  echo "==> Installing chezmoi and applying trodemaster config..."
  # Ensure curl is available (minimal image may not have it)
  sudo apt install -y curl
  # Run as target user so dotfiles and repo go to their home
  sudo -u "$TARGET_USER" HOME="/home/$TARGET_USER" sh -c 'sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply trodemaster'
}

# ---- 3. Cleanup ----
cleanup() {
  echo "==> Cleanup..."
  sudo apt autoremove -y --purge || true
  >"/home/$TARGET_USER/.bash_history" 2>/dev/null || true
  sudo logrotate -f /etc/logrotate.conf 2>/dev/null || true
}

# ---- Main: run in order ----
install_open_vm_tools
install_chezmoi
cleanup

echo "==> configure.sh done."
