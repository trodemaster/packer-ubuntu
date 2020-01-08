#!/bin/bash
# Shell script to prep ubuntu vm 
# set vmware tools to debug logging
vmwtoolsdebug ()
{
   sudo mkdir -p /etc/vmware-tools/  
   sudo bash -c "echo 'log = "TRUE"' > /etc/vmware-tools/tools.conf"
   sudo bash -c "echo 'log.file = "/var/log/vmtools.log"' >> /etc/vmware-tools/tools.conf"
}

# newer release specific stuff
RELEASE=`/usr/bin/lsb_release -r|/usr/bin/awk '/Release/ { print $NF }' | cut -d . -f 1`

# load the latest updates
sudo apt-get update
sudo apt-get -y dist-upgrade
sudo apt-get -y install jq glances git 

# Disable IPv6 Privacy addresses
sudo bash -c "sed -i 's/net.ipv6.conf.all.use_tempaddr = 2/net.ipv6.conf.all.use_tempaddr = 0/g' /etc/sysctl.d/10-ipv6-privacy.conf" 
sudo bash -c "sed -i 's/net.ipv6.conf.default.use_tempaddr = 2/net.ipv6.conf.default.use_tempaddr = 0/g' /etc/sysctl.d/10-ipv6-privacy.conf" 

# set timezone to UTC
if [ -e /usr/bin/timedatectl ]
  then
    sudo timedatectl set-timezone Etc/UTC
  else
    sudo /bin/rm /etc/localtime
    sudo ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime
fi


# allow root login via ssh with password
sudo bash -c " sed -i 's/PermitRootLogin .*-password/PermitRootLogin yes/g' /etc/ssh/sshd_config"

# clear logs
sudo logrotate -f /etc/logrotate.conf

# Clear bash history
> ~/.bash_history

# remove gui splash from boot
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/' /etc/default/grub
# disable grub stall after hard power off (may be causing errors)
sudo bash -c "echo GRUB_RECORDFAIL_TIMEOUT=10 >> /etc/default/grub"
sudo update-grub

# remove some packages
sudo apt-get -y install byobu
sudo purge-old-kernels -y 
sudo apt-get -y autoremove --purge

# make .itc if needed
if [[ ! -d /root/.itc ]]; then
  sudo mkdir /root/.itc
fi

exit 0