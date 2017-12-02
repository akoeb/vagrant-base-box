#!/bin/bash
# Provisioning of the vagrant box:
# * install java 8 and maven

repofile="/etc/apt/sources.list.d/backports.list"

if [ ! -e "$repofile" ]
then
    echo 'deb http://ftp.debian.org/debian jessie-backports main' > $repofile
fi

if ! dpkg-query -W -f='${Status} ${Version}\n' maven
then
    apt-get update
    apt-get install --yes --no-install-recommends openjdk-8-jdk maven
fi

