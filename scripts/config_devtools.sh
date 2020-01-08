# setup profile
cat > /root/.bashrc <<"BASHPROFILE"
# golang and hashicorp
export GOPATH=/files/go
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/files/go/bin
export PATH=$PATH:/files/go/src/github.com/mitchellh/packer/bin
export PATH=$PATH:/files/go/src/github.com/hashicorp/terraform/bin

# prompt and friends
export PS1='\h:$PWD\$ '
export DISPLAY=:0
declare -x CLICOLOR=false

# Packer
export PACKER_LOG=1
export PACKER_LOG_PATH=/files/packer-itcloud/logs/packer-build.log

# GUI
export DISPLAY=:0

# Aliases
alias terraformhome="cd $GOPATH/src/github.com/hashicorp/terraform; echo -e \"\033[33m--> \`pwd\`\033[0m\""
alias terraformitc="cd /files/terraform-itcloud; echo -e \"\033[33m--> \`pwd\`\033[0m\""
alias packerhome="cd $GOPATH/src/github.com/mitchellh/packer; echo -e \"\033[33m--> \`pwd\`\033[0m\""
alias packeritc="cd /files/packer-itcloud; echo -e \"\033[33m--> \`pwd\`\033[0m\""
alias packerv="cd /files/packer-validation; echo -e \"\033[33m--> \`pwd\`\033[0m\""

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

#chmod 755 /home/ubuntu/.python/bin/aws
#which aws
#aws
# tune aws command options
#aws configure set default.s3.max_concurrent_requests 5
#aws configure set default.s3.max_queue_size 300
#aws configure set default.s3.multipart_threshold 64MB
#aws configure set default.s3.multipart_chunksize 128MB

# disable page table security features
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/GRUB_CMDLINE_LINUX_DEFAULT=\"pti=off\"/' /etc/default/grub
sudo update-grub

## lock down login
#sed -i 's/.*PermitRootLogin.*/PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config
#sed -i 's/.*ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config
#sed -i 's/.*PasswordAuthentication.*/PasswordAuthentication no/g' /etc/ssh/sshd_config
#
## destroy root password
#passwd -d root
#passwd -l root

# vm dir 
if [[ ! -e /files/vm ]]; then
  sudo mkdir -p /files/vm
  sudo chmod -R 777 /files
fi