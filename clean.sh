#!/bin/bash
# This script zeroes out any space not needed for packaging a new Ubuntu Vagrant base box.
# Run the following command in a root shell:
#
# bash <(curl -s https://gist.github.com/justindowning/5670884/raw/vagrant-clean.sh)

function print_green {
  echo -e "\e[32m${1}\e[0m"
}

print_green 'Clean Apt'
apt-get -y autoremove
aptitude clean
aptitude autoclean

print_green 'Cleanup bash history'
history -c
unset HISTFILE
[ -f /root/.bash_history ] && cat /dev/null > /root/.bash_history
[ -f /home/vagrant/.bash_history ] && cat /dev/null > /home/vagrant/.bash_history
 
print_green 'Cleanup log files'
find /var/log -type f | while read f; do echo -ne '' > $f; done

print_green 'Remove APT lists'
rm -rf /var/lib/apt/lists/*

print_green 'removing sources'
rm -rf /usr/src/linux-headers*
rm -rf /usr/src/vboxguest*
rm -rf /opt/VBoxGuestAdditions-*/src/

# whiteout swap
swappart=`cat /proc/swaps | grep -v Filename | tail -n1 | awk -F ' ' '{print $1}'`
if [ -n "$swappart" ]; then
    print_green "Whiteout swap part $swappart"
    old_uuid=$(blkid $swappart -s UUID -o value)
    swapoff $swappart
    dd if=/dev/zero of=$swappart
    mkswap -f $swappart
    swapon $swappart

    # swap has a different uuid now, change fstab:
    new_uuid=$(blkid $swappart -s UUID -o value)
    sed "s/$old_uuid/$new_uuid/" -i /etc/fstab
fi


print_green 'Whiteout root'
count=`df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}'`
let count--
dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count
rm /tmp/whitespace


# block until all disk writes are done
sync

print_green 'Vagrant cleanup complete!'
