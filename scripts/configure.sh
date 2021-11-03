#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
shopt -s nullglob nocaseglob

# modern bash version check
! [ "${BASH_VERSINFO:-0}" -ge 4 ] && echo "This script requires bash v4 or later" && exit 1

# path to self and parent dir
SCRIPT=$(realpath $0)
SCRIPTPATH=$(dirname $SCRIPT)

# configurables
GO_VERSION="1.17.2"
if [[ $(uname -m) == "x86_64" ]]; then
  LINUX_ARCH="amd64"
elif [[ $(uname -m) == "aarch64" ]]; then
  LINUX_ARCH="arm64"
fi

# install open-vm-tools as needed
if sudo dmidecode | grep "Vendor: VMware"; then
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
fi

# wait for apt to be ready
while sudo fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do
   echo "waiting for apt to be ready"
   sleep 1
done

# load the latest updates & packages
sudo apt update
sudo apt -y dist-upgrade
sudo apt -y install jq glances git wget unzip tmux python3 python3-pip python-is-python3 docker mlocate byobu avahi-daemon
sudo purge-old-kernels -y
sudo apt autoremove --purge

# Disable IPv6 Privacy addresses
sudo sed -i 's/net.ipv6.conf.all.use_tempaddr = 2/net.ipv6.conf.all.use_tempaddr = 0/g' /etc/sysctl.d/10-ipv6-privacy.conf
sudo sed -i 's/net.ipv6.conf.default.use_tempaddr = 2/net.ipv6.conf.default.use_tempaddr = 0/g' /etc/sysctl.d/10-ipv6-privacy.conf

# fixup sshd_conf
sudo sed -i 's/#AllowAgentForwarding yes/AllowAgentForwarding yes/g' /etc/ssh/sshd_config

# set timezone to UTC
if [[ -e /usr/bin/timedatectl ]];then
  sudo timedatectl set-timezone US/Pacific
fi

# create code dir
if ! [[ -d ~/code ]]; then
  mkdir ~/code
fi

# install golang
wget -q -O go${GO_VERSION}.linux-${LINUX_ARCH}.tar.gz https://golang.org/dl/go${GO_VERSION}.linux-${LINUX_ARCH}.tar.gz 
sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-${LINUX_ARCH}.tar.gz
PATH=$PATH:/usr/local/go/bin
go version
rm go${GO_VERSION}.linux-${LINUX_ARCH}.tar.gz
export GOPATH=${HOME}/code/go

# install packages using go get
go install github.com/minio/mc@latest
go install github.com/muesli/duf@latest
go install github.com/junegunn/fzf@latest
wget -q -O ${HOME}/.fzf_completion.bash https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.bash
wget -q -O ${HOME}/.fzf_key-bindings.bash https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.bash

# python packages
python -m pip install powerline-status

# install source code pro font
wget -q https://github.com/adobe-fonts/source-code-pro/releases/download/2.038R-ro%2F1.058R-it%2F1.018R-VAR/OTF-source-code-pro-2.038R-ro-1.058R-it.zip
if ! [[ -d ${HOME}/.fonts ]]; then
  mkdir ${HOME}/.fonts
fi

unzip -o -d ${HOME}/.fonts ${HOME}/OTF-source-code-pro*.zip
rm ${HOME}/OTF-source-code-pro*.zip

# add powerline config file
if ! [[ -d ~/.config/powerline ]]; then
  mkdir -p ~/.config/powerline
  mv config.json ~/.config/powerline/
fi

# setup profile
cat <<'PROFILE' > ${HOME}/.bash_profile
export GOPATH=${HOME}/code/go
export PATH=$PATH:${HOME}/code/go/bin:${HOME}/.local/bin/
export TERM=xterm-color-256
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export CLICOLOR=1

if [[ -e ${HOME}/.fzf_completion.bash ]]; then
  source ${HOME}/.fzf_completion.bash
fi

if [[ -e ${HOME}/.fzf_key-bindings.bash ]]; then
  source ${HOME}/.fzf_key-bindings.bash
fi

export HISTCONTROL=ignoredups:erasedups # no duplicate entries
export HISTSIZE=100000                  # big big history
export HISTFILESIZE=100000              # big big history
shopt -s histappend                     # append to history, don't overwrite it

# prompt
export PS1="\[\e[;34m\]\u\[\e[1;37m\]@\h\[\e[;32m\]:\W$ \[\e[0m\]"

# seup powerline
if ( command -v powerline-daemon > /dev/null 2>&1 ); then
  if [[ $(tty) =~ "dev/pts" ]];then
    powerline-daemon -q
    export POWERLINE_BASH_CONTINUATION=1
    export POWERLINE_BASH_SELECT=1
    source ${HOME}/.local/lib/python3*/site-packages/powerline/bindings/bash/powerline.sh
  fi
fi

PROFILE

# hashicorp
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=${LINUX_ARCH}] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update
sudo apt install packer terraform vault
vault version
packer version
terraform version

# clear logs
sudo logrotate -f /etc/logrotate.conf

# Clear bash history
> ~/.bash_history