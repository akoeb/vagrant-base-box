#!/bin/bash
# Provisioning of the vagrant box:
# * install newet docker and compose

repofile="/etc/apt/sources.list.d/docker.list"


# install apt-transport-https
if ! dpkg-query -W -f='${Status} ${Version}\n' apt-transport-https 2>/dev/null
then
    apt-get update
    apt-get install --yes apt-transport-https ca-certificates
fi

# add docker repo
if [ ! -e "$repofile" ]
then
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    echo 'deb https://apt.dockerproject.org/repo debian-jessie main' > $repofile
fi


# docker 
if ! dpkg-query -W -f='${Status} ${Version}\n' docker-engine 2>/dev/null
then
    sudo apt-get update
    sudo apt-get --yes install docker-engine
fi

# docker-compose
if [ ! -e /usr/local/bin/docker-compose ]
then
    curl -s https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi
