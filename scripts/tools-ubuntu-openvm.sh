#!/bin/bash
# Install open vmware tools for ubuntu

# determine distro major version number
RELEASE=`/usr/bin/lsb_release -r|/usr/bin/awk '/Release/ { print $NF }' | cut -d . -f 1 2>/dev/null`

echo "Ubuntu Release ${RELEASE}"

if [[ "${RELEASE}" = "14" ]]; then
  echo "Installing open-vm-tools-deploypkg from vmware.com"	
  # Download package certs from vmware
  wget http://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-DSA-KEY.pub -O /tmp/VMWARE-PACKAGING-GPG-DSA-KEY.pub
  wget http://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-RSA-KEY.pub -O /tmp/VMWARE-PACKAGING-GPG-RSA-KEY.pub
  
  # install package certs from vmware
  sudo apt-key add /tmp/VMWARE-PACKAGING-GPG-DSA-KEY.pub
  sudo apt-key add /tmp/VMWARE-PACKAGING-GPG-RSA-KEY.pub
  
  # Configure repo for deploypkg
  sudo bash -c "echo deb http://packages.vmware.com/packages/ubuntu `lsb_release -c -s` main > /etc/apt/sources.list.d/vmware-tools.list"
  
  # Refresh package lists for all repo
  sudo apt-get update
  
  # Install open vm tool and deploypkg
  sudo apt-get -y install open-vm-tools-deploypkg --force-yes
fi

if [[ "${RELEASE}" -ge "16" ]]; then
  echo "Installing open-vm-tools from repo"
  sudo apt-get -y install open-vm-tools
fi

# Report the version of tools installed
if [ -e /usr/bin/vmware-toolbox-cmd ]; then
    echo "VMware tools version"
    /usr/bin/vmware-toolbox-cmd --version
  else
    echo "VMware Tools Failed to install..."
    exit 1
fi