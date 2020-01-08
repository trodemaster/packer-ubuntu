#!/usr/bin/env bash
set -euo pipefail 
IFS=$'\n\t'
shopt -s nullglob 
shopt -s nocaseglob 

# wait for apt to be ready
while sudo fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/{lock,lock-frontend} >/dev/null 2>&1; do
   echo "waiting for apt to be ready"
   sleep 1
done

# install the gui
echo "Installing  desktop env..."
sudo apt-get update
sudo apt-get install -y --install-recommends linux-generic-hwe-18.04 xserver-xorg-hwe-18.04 xserver-xorg-core-hwe-18.04
sudo apt-get install -y xserver-xorg xserver-xorg-core
sudo apt-get install -y open-vm-tools-desktop
sudo apt-get install -y budgie-lightdm-theme budgie-desktop-minimal tilix lightdm-settings ubuntu-budgie-themes
sudo apt-get install -y tigervnc-common tigervnc-standalone-server tigervnc-xorg-extension tigervnc-scraping-server

#sudo apt-get -y install xfce4 xfce4-goodies 
#sudo apt-get -y install slick-greeter lightdm --no-install-recommends

echo "/home/ubuntu/startvnc start >/dev/null 2>&1" >> ~/.xsessionrc
mkdir /home/ubuntu/.vnc
echo 'Ubuntu19!' | vncpasswd -f > /home/ubuntu/.vnc/passwd
chmod +x /home/ubuntu/startvnc
sudo systemctl set-default graphical.target

## chrome
sudo apt-get install -y chromium-browser
#wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#sudo apt-get install -y fonts-liberation indicator-application
#sudo dpkg -i google-chrome-stable_current_amd64.deb
#rm google-chrome-stable_current_amd64.deb

