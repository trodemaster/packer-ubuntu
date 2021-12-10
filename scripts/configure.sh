#!/usr/bin/env bash
shopt -s nullglob nocaseglob
IFS=$'\n\t'

# modern bash version check
! [ "${BASH_VERSINFO:-0}" -ge 4 ] && echo "This script requires bash v4 or later" && exit 1

# path to self and parent dir
SCRIPT=$(realpath $0)
SCRIPTPATH=$(dirname $SCRIPT)

# VARS
if ${CONFIG_VM+x};then
  echo "set $CONFIG_VM"
else
  echo "unset CONFIG_VM"
  CONFIG_VM=0
fi

echo "config container env var $CONFIG_CONTAINER"
if [[ -z $CONFIG_CONTAINER ]];then
  echo "unset CONFIG_CONTAINER"
  CONFIG_CONTAINER=0
else
  echo "CONFIG_CONTAINER set to $CONFIG_CONTAINER from env var"
fi

if [[ -z $CONFIG_GOLANG ]];then
  echo "unset CONFIG_GOLANG"
  CONFIG_GOLANG=0
else
  echo "CONFIG_GOLANG set to $CONFIG_GOLANG from env var"
fi

if [[ -z $CONFIG_HASHICORP ]];then
  echo "unset CONFIG_HASHICORP"
  CONFIG_HASHICORP=0
else
  echo "CONFIG_HASHICORP set to $CONFIG_HASHICORP from env var"
fi

if [[ -z $CONFIG_PROMPT ]];then
  echo "unset CONFIG_PROMPT"
  CONFIG_PROMPT=0
else
  echo "CONFIG_PROMPT set to $CONFIG_PROMPT from env var"
fi

# need to set bash strict mode after slurping up vars
set -euo pipefail

# print out usage
usage() {
  cat <<EOF
USAGE: ./configure.sh -v
OPTIONS:
   -v    vm
   -c    container
   -g    golang
   -t    hashicorp
   -p    prompt
   -h    Help
EOF
  exit
}

# process options and arguments
while getopts "vcgthp" OPTION; do
  case $OPTION in
  h) usage && exit 1 ;;
  p) INPUT_PATH=$OPTARG ;;
  o) OUTPUT_PATH=$OPTARG ;;
  t) THING_1=0 ;;
  d) HD_ARCHIVE=0 ;;
  b) BADPEG=0 ;;
  esac
done

# configurables
GO_VERSION="1.17.2"
if [[ $(uname -m) == "x86_64" ]]; then
  LINUX_ARCH="amd64"
elif [[ $(uname -m) == "aarch64" ]]; then
  LINUX_ARCH="arm64"
fi

vmware_tools() {
  # install open-vm-tools as needed
  if sudo dmidecode | grep "Vendor: VMware"; then
    sudo apt update
    sudo apt -y install open-vm-tools
    # Report the version of tools installed
    if [ -e /usr/bin/vmware-toolbox-cmd ]; then
      echo "VMware tools version"
      /usr/bin/vmware-toolbox-cmd --version
    else
      echo "VMware Tools Failed to install..."
      exit 1
    fi
  fi
}

remove_snaps() {
  # remove snaps
  if [[ -f /bin/running-in-container ]]; then
    echo "running in container"
  else
    sudo snap remove lxd
    sudo systemctl stop snapd
    sudo apt -y purge snapd
    rm -rf ~/snap
    sudo rm -rf /snap
    sudo rm -rf /var/snap
    sudo rm -rf /var/lib/snapd
  fi
}

vm_packages() {

  # load the latest updates & packages
  export DEBIAN_FRONTEND=noninteractive
  sudo apt update
  sudo apt -y dist-upgrade
  sudo apt -y install jq glances git wget unzip tmux python3 python3-pip python-is-python3 mlocate byobu avahi-daemon avahi-discover avahi-utils libnss-mdns mdns-scan tree acl apt-transport-https
  sudo purge-old-kernels -y
  sudo apt autoremove --purge

}

container_packages() {
  # load the latest updates & packages
  export DEBIAN_FRONTEND=noninteractive
  apt update
  apt -y install dumb-init ssh iproute2 jq glances git wget unzip tmux python3 python3-pip python-is-python3 mlocate tree acl apt-transport-https
  apt autoremove --purge
}

container_sshd() {
  mkdir -p /usr/local/bin
  mv /tmp/sshd /usr/local/bin/sshd
  chmod +x /usr/local/bin/sshd
  cat <<SSHDCONFIG >/etc/ssh/sshd_config.d/devcntr
PermitRootLogin prohibit-password
Port 443
SSHDCONFIG
}

vm_config() {

  # Disable IPv6 Privacy addresses
  sudo sed -i 's/net.ipv6.conf.all.use_tempaddr = 2/net.ipv6.conf.all.use_tempaddr = 0/g' /etc/sysctl.d/10-ipv6-privacy.conf
  sudo sed -i 's/net.ipv6.conf.default.use_tempaddr = 2/net.ipv6.conf.default.use_tempaddr = 0/g' /etc/sysctl.d/10-ipv6-privacy.conf

  # fixup sshd_conf
  sudo sed -i 's/#AllowAgentForwarding yes/AllowAgentForwarding yes/g' /etc/ssh/sshd_config

  # set timezone to UTC
  if [[ -e /usr/bin/timedatectl ]]; then
    sudo timedatectl set-timezone US/Pacific
  fi

  # create code dir
  if ! [[ -d ~/code ]]; then
    mkdir ~/code
  fi
  
  # remove cloud-init
  sudo apt -y remove cloud-init

}

golang() {
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

}

prompt() {
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
  cat <<'PROFILE' >${HOME}/.bash_profile
export GOPATH=${HOME}/code/go
export PATH=$PATH:${HOME}/code/go/bin:${HOME}/.local/bin/
export TERM=xterm-256color
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

# aliases
alias ls="ls -1"
alias eaw="sudo setfacl -m u:${USER}:rw"

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

  # remove motd
  touch $HOME/.hushlogin

}

hashicorp() {
  # k8s
  sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
  echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
  sudo apt update
  sudo apt install -y kubectl

  # hashicorp
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
  sudo apt-add-repository "deb [arch=${LINUX_ARCH}] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  sudo apt update
  sudo apt install -y packer || true
  sudo apt install -y terraform || true
  sudo apt install -y vault || true
  vault version || true
  packer version || true
  terraform version || true
}

cleanup() {
  # clear logs
  sudo logrotate -f /etc/logrotate.conf

  # Clear bash history
  >~/.bash_history
}

#echo "config vm $CONFIG_VM"
#if [[ $CONFIG_VM == "1" ]];then
#echo "doing config vm"
#  vmware_tools
#  vm_config
#  vm_packages
#  remove_snaps
#  golang
#  hashicorp
#  prompt
#  cleanup
#fi

echo "config container $CONFIG_CONTAINER"
if [[ $CONFIG_CONTAINER =~ "1" ]];then
echo "doing container build"
  container_packages
  container_sshd
#  golang
#  hashicorp
#  prompt
fi
