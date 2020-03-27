#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# test download url
if [[ `curl --silent --head --location --output /dev/null --connect-timeout 5 --write-out '%{http_code}' ${blob_webserver}setup64.exe | grep '^2'` == 200 ]] ; then
  echo "$blob_webserver contacted!"
else
  echo "$blob_webserver not found!"
  exit 1
fi   	

# clear logs
# fix ping with QEMU
#sysctl -w net.ipv4.ping_group_range='0 2147483647'
echo 'net.ipv4.ping_group_range ="0 2147483647"' >> /etc/sysctl.conf

# install tools
echo "Updating apg-get packages.." 
apt-get -q -y update &>> /tmp/update.log
apt-get --yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade &>> /tmp/update.log 
apt-get -y install software-properties-common apt-transport-https &>> /tmp/update.log
purge-old-kernels -y --keep 1 &>> /tmp/update.log
apt-get -y autoremove --purge &>> /tmp/update.log
echo "adding lots of needed packaes"
apt-get install -y htop tmux git make pigz libxcursor1 bmon jq ntfs-3g pkg-config &>> /tmp/update.log
apt-get install -y libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev libibverbs-dev lsof libjpeg8-dev libncurses5-dev libnuma-dev libusb-dev libusbredirparser-dev &>> /tmp/update.log
apt-get -y install python-dev python-pip virtualenv &>> /tmp/update.log
apt-get -y autoremove --purge

# install powercli
# Import the public repository GPG keys
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
# Register the Microsoft Ubuntu repository
curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/microsoft.list
apt-get update
apt-get install -y powershell

# install powercli from PSGallery
pwsh -command 'Set-PSRepository -Name PSGallery -InstallationPolicy Trusted'
pwsh -command 'Install-Module -Name VMware.PowerCLI -Scope CurrentUser'
pwsh -command 'Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $true -confirm:$false'
pwsh -command 'Set-PowerCLIConfiguration -InvalidCertificateAction ignore -confirm:$false'

virtualenv /root/.packerws_python
export VIRTUAL_ENV_DISABLE_PROMPT=1
source /root/.packerws_python/bin/activate
pip install --upgrade pip
pip install python-openstackclient
pip install awscli
chmod 755 /root/.packerws_python/bin/aws

# tune aws command options
aws configure set default.s3.max_concurrent_requests 5
aws configure set default.s3.max_queue_size 300
aws configure set default.s3.multipart_threshold 64MB
aws configure set default.s3.multipart_chunksize 128MB

# disable page table security features
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/GRUB_CMDLINE_LINUX_DEFAULT=\"pti=off\"/' /etc/default/grub
update-grub

# purge salt repo
/bin/rm /etc/apt/sources.list.d/saltstack.list
apt-get -y remove salt-minion

# cleanup after install
#apt-get -y autoremove

# setup root ssh key
if [[ ! -e /root/.ssh ]]; then
  mkdir /root/.ssh
fi
echo "" > /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

# lock down login
sed -i 's/.*PermitRootLogin.*/PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config
sed -i 's/.*ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/.*PasswordAuthentication.*/PasswordAuthentication no/g' /etc/ssh/sshd_config

# destroy root password
#passwd -d root
#passwd -l root

# setup qemu
QEMU_VERSION="qemu-4.2.0"
wget https://download.qemu.org/$QEMU_VERSION.tar.xz -O /var/tmp/qemu.tar.xz
tar xJf /var/tmp/qemu.tar.xz -C /var/tmp/
cd /var/tmp/$QEMU_VERSION
./configure --target-list=x86_64-softmmu
make -j2
make install
cd /var/tmp/
/bin/rm -r /var/tmp/qemu*

#install workstation
echo "Installing VMware Workstation"
wget -q -O /var/tmp/VMware-Workstation.bundle https://www.vmware.com/go/getworkstation-linux
chmod +x /var/tmp/VMware-Workstation.bundle
/bin/bash /var/tmp/VMware-Workstation.bundle --console --eulas-agreed --required

# setup profile
cat > /root/.bashrc <<"BASHPROFILE"

# prompt and friends
export PS1="\[\e[;34m\]\u\[\e[1;37m\]@\h\[\e[;32m\]:\w$ \[\e[0m\]"
export DISPLAY=:0
declare -x CLICOLOR=1

# python virtualenv
export VIRTUAL_ENV_DISABLE_PROMPT=1
source /root/.packerws_python/bin/activate
BASHPROFILE

# fixup profile
chown root:root /root/.bashrc
chmod +x /root/.bashrc

# create aws config dir
if [[ ! -e /root/.aws ]]; then
  mkdir -p /root/.aws
fi

# install golang
wget -q -o /var/tmp/update-golang.sh https://raw.githubusercontent.com/udhos/update-golang/master/update-golang.sh
if [[ -e /var/tmp/update-golang.sh ]]; then
	chmod +x /var/tmp/update-golang.sh
  /var/tmp/update-golang.sh
else
	echo "golang install script failed to download!!"
	exit 1	
fi






