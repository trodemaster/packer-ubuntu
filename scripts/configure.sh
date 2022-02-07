#!/usr/bin/env bash
shopt -s nullglob nocaseglob
IFS=$'\n\t'

# modern bash version check
! [ "${BASH_VERSINFO:-0}" -ge 4 ] && echo "This script requires bash v4 or later" && exit 1

# path to self and parent dir
SCRIPT=$(realpath $0)
SCRIPTPATH=$(dirname $SCRIPT)

echo "config VM env var $CONFIG_VM"
if [[ -z $CONFIG_VM ]]; then
  echo "unset CONFIG_VM"
  CONFIG_VM=0
else
  echo "CONFIG_CONTAINER set to $CONFIG_CONTAINER from env var"
  SUDOCMD="sudo"
fi

echo "config container env var $CONFIG_CONTAINER"
if [[ -z $CONFIG_CONTAINER ]]; then
  echo "unset CONFIG_CONTAINER"
  CONFIG_CONTAINER=0
else
  echo "CONFIG_CONTAINER set to $CONFIG_CONTAINER from env var"
  SUDOCMD=""
  HOME="/"
fi

if [[ -z $CONFIG_GOLANG ]]; then
  echo "unset CONFIG_GOLANG"
  CONFIG_GOLANG=0
else
  echo "CONFIG_GOLANG set to $CONFIG_GOLANG from env var"
fi

if [[ -z $CONFIG_HASHICORP ]]; then
  echo "unset CONFIG_HASHICORP"
  CONFIG_HASHICORP=0
else
  echo "CONFIG_HASHICORP set to $CONFIG_HASHICORP from env var"
fi

if [[ -z $CONFIG_PROMPT ]]; then
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
GO_VERSION="1.17.5"
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
  sudo apt -y install jq glances git wget unzip tmux python3 python3-pip python-is-python3 mlocate byobu avahi-daemon avahi-discover avahi-utils libnss-mdns mdns-scan tree acl apt-transport-https ca-certificates curl gnupg lsb-release
  sudo purge-old-kernels -y
  sudo apt autoremove --purge
}

docker() {
  sudo apt -y remove docker docker-engine docker.io containerd runc
  # curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  # echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
  sudo apt update
  #sudo apt -y install docker-ce docker-ce-cli containerd.io
  curl -fsSL test.docker.com -o get-docker.sh && sh get-docker.sh
  #  sudo groupadd docker
  sudo usermod -aG docker $USER
}

container_packages() {
  # load the latest updates & packages
  export DEBIAN_FRONTEND=noninteractive
  apt update
  apt -y install dumb-init ssh iproute2 jq glances git wget unzip tmux python3 python3-pip python-is-python3 mlocate tree acl apt-transport-https curl nmap traceroute apt-utils software-properties-common bind9-dnsutils netcat neovim
  apt autoremove --purge
}

container_sshd() {
  mkdir -p /usr/local/bin
  mv /tmp/sshd /usr/local/bin/sshd
  chmod +x /usr/local/bin/sshd
  echo $SSH_KEY >/etc/ssh/authorized_keys
  cat <<SSHDCONFIG >/etc/ssh/sshd_config.d/devcntr.conf
PermitRootLogin prohibit-password
AuthorizedKeysFile /etc/ssh/authorized_keys
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
  $SUDOCMD tar -C /usr/local -xzf go${GO_VERSION}.linux-${LINUX_ARCH}.tar.gz
  PATH=$PATH:/usr/local/go/bin
  go version
  rm go${GO_VERSION}.linux-${LINUX_ARCH}.tar.gz
  export GOPATH=${HOME}/code/go

  # install packages using go get
  go install github.com/minio/mc@latest
  #go install github.com/muesli/duf@latest
  go install github.com/junegunn/fzf@latest
  go install filippo.io/age/cmd/...@latest
  wget -q -O ${HOME}/.fzf_completion.bash https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.bash
  wget -q -O ${HOME}/.fzf_key-bindings.bash https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.bash

}

prompt() {
  # python packages
  python -m pip install powerline-status

  # install source code pro font
  wget https://github.com/adobe-fonts/source-code-pro/releases/download/2.038R-ro%2F1.058R-it%2F1.018R-VAR/OTF-source-code-pro-2.038R-ro-1.058R-it.zip
  if ! [[ -d ${HOME}/.fonts ]]; then
    mkdir ${HOME}/.fonts
  fi

  unzip -o -d ${HOME}/.fonts ${HOME}/OTF-source-code-pro*.zip
  rm ${HOME}/OTF-source-code-pro*.zip

  # add powerline config file
  if ! [[ -d ~/.config/powerline ]]; then
    mkdir -p ~/.config/powerline
    mv /tmp/config.json ~/.config/powerline/
  fi

  # setup profile
  cat <<'PROFILE' >${HOME}/.bash_profile
export GOPATH=${HOME}/code/go
export PATH=$PATH:/usr/local/go/bin:${HOME}/code/go/bin:${HOME}/.local/bin/
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

container_prompt() {
  # python packages
  python -m pip install powerline-status

  # install source code pro font
  wget -q https://github.com/adobe-fonts/source-code-pro/releases/download/2.038R-ro%2F1.058R-it%2F1.018R-VAR/OTF-source-code-pro-2.038R-ro-1.058R-it.zip -O /tmp/OTF-source-code-pro.zip
  unzip -o -d /usr/local/share/fonts /tmp/OTF-source-code-pro.zip SourceCodePro-Medium.otf
  rm /tmp/OTF-source-code-pro.zip

  # add powerline config file
  if ! [[ -d ${HOME}/.config/powerline ]]; then
    mkdir -p ${HOME}/.config/powerline
    mv /tmp/config.json ${HOME}/.config/powerline/
  fi

  # setup profile
  cat <<'PROFILE' >/etc/profile.d/02-bash-profile.sh
export GOPATH=/opt/go
export PATH=$PATH:/usr/local/go/bin:/opt/go/bin
export TERM=xterm-256color
export CLICOLOR=1

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
}

hashicorp() {
  # k8s
  $SUDOCMD curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
  echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | $SUDOCMD tee /etc/apt/sources.list.d/kubernetes.list
  $SUDOCMD apt update
  $SUDOCMD apt install -y kubectl

  # hashicorp
  curl -fsSL https://apt.releases.hashicorp.com/gpg | $SUDOCMD apt-key add -
  $SUDOCMD apt-add-repository "deb [arch=${LINUX_ARCH}] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  $SUDOCMD apt update
  $SUDOCMD apt install -y packer || true
  $SUDOCMD apt install -y terraform || true
  $SUDOCMD apt install -y vault || true
  $SUDOCMD apt install --reinstall -y vault || true
  vault version || true
  packer version || true
  terraform version || true
}

apt_repo() {
  if ! [[ $APT_REPO =~ "us.archive.ubuntu.com" ]]; then
    echo "updating apt repo"
    $SUDOCMD sed -i "s/us.archive.ubuntu.com\/ubuntu/$APT_REPO/g" /etc/apt/sources.list
    cat /etc/apt/sources.list
  fi
}

cleanup() {
  # clear logs
  $SUDOCMD logrotate -f /etc/logrotate.conf

  # Clear bash history
  >~/.bash_history
}

if [[ $CONFIG_VM =~ "1" ]]; then
  echo "########vmware_tools########"
  vmware_tools
  echo "########vm_config########"
  vm_config
  echo "########vm_packages########"
  vm_packages
  echo "########remove_snaps########"
  remove_snaps
  echo "########golang########"
  golang
  echo "########hashicorp########"
  hashicorp
  echo "########docker########"
  docker
  echo "########prompt########"
  prompt
  echo "########apt_repo########"
  apt_repo
  echo "########cleanup########"
  cleanup
fi

if [[ $CONFIG_CONTAINER =~ "1" ]]; then
  echo "########container_packages########"
  container_packages
  echo "########container_sshd########"
  container_sshd
  echo "########golang########"
  golang
  echo "########hashicorp########"
  hashicorp
  echo "########prompt########"
  container_prompt
  echo "########apt_repo########"
  apt_repo
fi
