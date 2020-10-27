#!/bin/bash
# Shell script to prep ubuntu vm 

# wait for apt to be ready
while sudo fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do
   echo "waiting for apt to be ready"
   sleep 1
done

# load the latest updates
sudo apt update
sudo apt -y dist-upgrade
sudo apt -y install jq glances git 

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

# clear logs
sudo logrotate -f /etc/logrotate.conf

# Clear bash history
> ~/.bash_history

# remove gui splash from boot
#sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/' /etc/default/grub
# disable grub stall after hard power off (may be causing errors)
#sudo bash -c "echo GRUB_RECORDFAIL_TIMEOUT=10 >> /etc/default/grub"
#sudo update-grub

## remove some packages
#sudo apt install byobu
#sudo purge-old-kernels -y 
#sudo apt autoremove --purge

exit 0