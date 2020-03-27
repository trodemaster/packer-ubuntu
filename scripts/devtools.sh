#!/usr/bin/env bash
#set -euo pipefail 
IFS=$'\n\t'
shopt -s nullglob 
shopt -s nocaseglob 

# wait for apt to be ready
while sudo fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do
   echo "waiting for apt to be ready"
   sleep 1
done

# install tool to unzip
sudo apt-get install -y p7zip-full glances 

# install release version of packer
wget --quiet --output-document /var/tmp/packer_linux_amd64.zip https://releases.hashicorp.com/packer/1.5.1/packer_1.5.1_linux_amd64.zip
if [[ -e /var/tmp/packer_linux_amd64.zip ]]; then
sudo 	7z x /var/tmp/packer_linux_amd64.zip -o/usr/local/bin/
sudo chmod +x /usr/local/bin/packer
else
	echo "packer download failed!!"
	exit 1	
fi

# make sure packer installed
unset PACKER_LOG
unset PACKER_LOG_PATH
if ! packer version ; then
  echo "packer failed to install!"
  exit 1
fi  

# terraform install
wget --quiet --output-document /var/tmp/terraform_linux_amd64.zip https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip
if [[ -e /var/tmp/terraform_linux_amd64.zip ]]; then
sudo 	7z x /var/tmp/terraform_linux_amd64.zip -o/usr/local/bin/
sudo chmod +x /usr/local/bin/terraform
else
	echo "terraform download failed!!"
	exit 1	
fi

# make sure terraform installed
unset TF_LOG
unset TF_LOG_PATH
if ! terraform version ; then
  echo "terraform failed to install!"
  exit 1
fi  

# vault install
wget --quiet --output-document /var/tmp/vault_linux_amd64.zip https://releases.hashicorp.com/vault/1.3.1/vault_1.3.1_linux_amd64.zip
if [[ -e /var/tmp/vault_linux_amd64.zip ]]; then
sudo 	7z x /var/tmp/vault_linux_amd64.zip -o/usr/local/bin/
sudo chmod +x /usr/local/bin/vault
else
	echo "vault download failed!!"
	exit 1	
fi

# make sure vault installed
unset TF_LOG
unset TF_LOG_PATH
if ! vault version ; then
  echo "vault failed to install!"
  exit 1
fi  



# fix ping with QEMU
sudo tee -a /etc/sysctl.conf <<< 'net.ipv4.ping_group_range=0 2147483647'

# install tools
echo "Updating apg-get packages.." 
#sudo apt-get -y update #
#sudo apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade # 
#sudo apt-get -y install software-properties-common apt-transport-https # 
#sudo purge-old-kernels -y --keep 1 
#sudo apt-get -y autoremove --purge 
echo "adding lots of needed packaes"
sudo apt-get install -y htop tmux git make pigz libxcursor1 bmon jq ntfs-3g pkg-config build-essential flex libaio1 libpcsclite1 tree bison
sudo apt-get install -y libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev libibverbs-dev lsof libjpeg8-dev libncurses5-dev libnuma-dev libusb-dev libusbredirparser-dev 
sudo apt-get -y install python-dev python-pip virtualenv 

# install powercli
# Import the public repository GPG keys
curl -s https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
# Register the Microsoft Ubuntu repository
curl -s https://packages.microsoft.com/config/ubuntu/18.04/prod.list | sudo tee /etc/apt/sources.list.d/microsoft.list
sudo apt-get update
sudo apt-get install -y powershell

# install powercli from PSGallery
pwsh -command 'Set-PSRepository -Name PSGallery -InstallationPolicy Trusted'
pwsh -command 'Install-Module -Name VMware.PowerCLI -Scope CurrentUser'
pwsh -command 'Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $true -confirm:$false'
pwsh -command 'Set-PowerCLIConfiguration -InvalidCertificateAction ignore -confirm:$false'

#virtualenv /home/ubuntu/.python
#export VIRTUAL_ENV_DISABLE_PROMPT=1
#source /home/ubuntu/.python/bin/activate
#pip install --upgrade pip
sudo pip install python-openstackclient
sudo pip install awscli
echo "awscli installed"



# setup qemu
QEMU_VERSION="qemu-4.1.0"
wget https://download.qemu.org/$QEMU_VERSION.tar.xz -O /var/tmp/qemu.tar.xz
tar xJf /var/tmp/qemu.tar.xz -C /var/tmp/
cd /var/tmp/$QEMU_VERSION
./configure --target-list=x86_64-softmmu
make -j2
sudo make install
cd /var/tmp/
/bin/rm -r /var/tmp/qemu*

#install workstation
echo "Installing VMware Workstation"
curl -s -J -L https://www.vmware.com/go/getWorkstation-linux -o /var/tmp/workstation-linux.bundle
chmod +x /var/tmp/workstation-linux.bundle
sudo /bin/bash /var/tmp/workstation-linux.bundle --console --eulas-agreed --required #--set-setting vmware-workstation serialNumber THENUMBER
rm /var/tmp/workstation-linux.bundle



# install golang
wget --quiet --output-document /var/tmp/go.linux-amd64.tar.gz https://dl.google.com/go/go1.12.9.linux-amd64.tar.gz
if [[ -e /var/tmp/go.linux-amd64.tar.gz ]]; then
	sudo tar xzf /var/tmp/go.linux-amd64.tar.gz -C /usr/local/
else
	echo "golang binaries not found!!"
	exit 1	
fi

mkdir -p /files/go
echo 'export GOPATH=/files/go' >> ~/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> ~/.bashrc

# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
sudo ~/.fzf/install --all







