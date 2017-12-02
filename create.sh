#!/bin/bash
# This script creates a vagrant base box:
# * starting a new vagrant machine with the provided Vagrantfile
# * package that machine
# * add the box


set -e

function build() {
    local dir=$1
    cd $dir
    source environment.sh

    # package running vm
    if [ -e ${FILENAME} ]
    then
        echo "Warning: old file ${FILENAME} exists, overwriting it" 1>&2
        rm ${FILENAME}
    fi


    # start new vm
    vagrant up

    # package and import
    vagrant package --output ${FILENAME}

    # destroy current box
    vagrant destroy -f


    # to add the box to the local vagrant environment, uncomment this line:
    #vagrant box add --name ${NAME} --force ${FILENAME}

    echo "The box is created with the name ${FILENAME}, you now may upload it to atlas"
    cd ..
}

# build all boxes:
for d in  docker java
do
   build $d
done


