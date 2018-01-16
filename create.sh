#!/bin/bash
# This script creates a vagrant base box:
# * starting a new vagrant machine with the provided Vagrantfile
# * package that machine
# * add the box


set -e

function build() {
    local dir=$1
    echo
    echo "Building $dir..."
    cd $dir
    source environment.sh

    # package running vm
    if [ -e ${FILENAME} ]
    then
        echo "Warning: old file ${FILENAME} exists, overwriting it" 1>&2
        rm ${FILENAME}
    fi

    # make sure vagrant uses the latest box available
    vagrant box update

    # start new vm
    vagrant up

    # package and import
    vagrant package --output ${FILENAME}

    # destroy current box
    vagrant destroy -f


    # to add the box to the local vagrant environment, uncomment this line:
    #vagrant box add --name ${NAME} --force ${FILENAME}

    echo "The box is created with the name ${FILENAME}, you now may upload it to atlas"
    echo
    cd ..
}

# which images to build depends on param
case "$1" in
    base)
        build base
        ;;
    docker)
        vagrant box remove -f akoeb/debian_offline || true
        build docker
        ;;
    java)
        vagrant box remove -f akoeb/docker_offline || true
        build java
        ;;
    derived)
        vagrant box remove -f akoeb/debian_offline || true
        build docker
        vagrant box remove -f akoeb/docker_offline || true
        build java
        ;;
    all)
        build base
        vagrant box remove -f akoeb/debian_offline || true
        build docker
        vagrant box remove -f akoeb/docker_offline || true
        build java
        ;;
    *)
        echo "Usage: $0 [base|docker|java|derived|all]"
        ;;
esac


