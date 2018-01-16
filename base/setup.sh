#!/bin/bash
# Provisioning of the vagrant box:
# * run dist-upgrades
# * install guest-additions
# * install my dotfiles

# I am living in Berlin:
timedatectl set-timezone Europe/Berlin

echo "deb http://ftp.debian.org/debian stretch-backports main contrib" >> /etc/apt/sources.list.d/stretch-backports.list

# first system update
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y dist-upgrade
apt-get -y install git vim vim-pathogen linux-headers-$(uname -r) build-essential dkms
apt-get -y install -t stretch-backports virtualbox-guest-dkms virtualbox-guest-x11 linux-headers-$(uname -r)

# add vagrant user to systemd-journal group
usermod -a -G systemd-journal vagrant

##**##  # get the vbox guest additions, version 5.1.30 hardcoded for now
##**##  GUEST_VERSION=5.1.30
##**##  wget -nv http://download.virtualbox.org/virtualbox/${GUEST_VERSION}/VBoxGuestAdditions_${GUEST_VERSION}.iso
##**##  
##**##  # mount the iso
##**##  mkdir /media/VBoxGuestAdditions
##**##  mount -o loop,ro VBoxGuestAdditions_${GUEST_VERSION}.iso /media/VBoxGuestAdditions
##**##  
##**##  # install guest additions
##**##  sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run
##**##  
##**##  # and remove installation artifacts
##**##  umount /media/VBoxGuestAdditions
##**##  rm VBoxGuestAdditions_${GUEST_VERSION}.iso
##**##  rmdir /media/VBoxGuestAdditions



# install my dotfiles:
cd /usr/local/src/
git clone https://github.com/akoeb/dotfiles.git
cd dotfiles
su - vagrant -c "/usr/local/src/dotfiles/dotfiles.sh install"

