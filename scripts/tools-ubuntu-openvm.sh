#!/bin/bash
# Install open vmware tools for ubuntu

sudo apt update
sudo apt install open-vm-tools

# Report the version of tools installed
if [ -e /usr/bin/vmware-toolbox-cmd ]; then
    echo "VMware tools version"
    /usr/bin/vmware-toolbox-cmd --version
  else
    echo "VMware Tools Failed to install..."
    exit 1
fi

exit 0