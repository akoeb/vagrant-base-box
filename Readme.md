# vagrant base box #

## Description ##

This is the stuff needed to create my vagrant base box. It is derived from debian/jessie, but it contains guest additions, git, vim and my personal dotfiles from 
https://www.github.com/akoeb/dotfiles

## Usage of the box ##


    vagrant init akoeb/debian
    vagrant up



## Creation of a new box ##

* run the create script
* use the box directly, add it to local vagrant with ```` vagrant package ```` or upload the box to atlas.


