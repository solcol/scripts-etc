#!/usr/bin/env bash

# SolCol.TomR.mez 2022
# https://github.com/solcol/scripts-etc

if [ "$EUID" -ne 0 ]; then
    echo "This script must be ran as root! Try prefacing your command with 'sudo' :)"
    exit 1
fi


# Actual commands that do stuff stolen from the doc on Teams, sorry Neil xx

if [[ ! -f "/root/.d006-wireless-ran" ]]; then
    echo -e "Looks like this is your first time running this script!\nWe'll need to download some things first\n\n"

    # haven't run the script before, need to update and install stuff 
    echo -e "\n\n\nUpdating Package Repos & Upgrading\n##########\n\n"
    apt update -y && apt upgrade -y

    echo -e "\n\n\nInstalling aircrack-ng, git & dkms\n##########\n\n"
    apt install aircrack-ng dkms git -y
else
    echo -e "Welcome back!\nThis isn't the first time you've run this script: let's get those kernel modules running!\n\n"
fi


if [[ ! -d "/usr/src/rtl88x2bu-git" ]]; then
    # doesn't exist, we need to clone it
    echo -e "\n\n\nCloning repository to /usr/src/rtl88x2bu-git\n##########\n\n"
    git clone https://github.com/RinCat/RTL88x2BU-Linux-Driver.git /usr/src/rtl88x2bu-git -v 
fi


if [[ ! -f "/root/.d006-wireless-ran" ]]; then
    # haven't run the script before, we need to install the kernel module
    echo -e "\n\n\nInstalling RTL88x2BU dynamic kernel module\n##########\n\n"
    sed -i 's/PACKAGE_VERSION="@PKGVER@"/PACKAGE_VERSION="git"/g' /usr/src/rtl88x2bu-git/dkms.conf
    dkms add -m rtl88x2bu -v git

    touch /root/.d006-wireless-ran
    echo -e "\a\n\n##########\n\nOkay, we're done for now!\nPlease reboot and run this script again to finish installing :)"
else
    # we've run the script before, let's install things
    echo -e "\n\n\nRunning dkms autoinstall\n##########\n\n"
    dkms autoinstall

    echo -e "\n\n\nEnabling kernel module right now\n##########\n\n"
    modprobe 88x2bu

    # \a = beep speaker!!
    echo -e "\a\n\n##########\n\nDone with everything... hopefully! You may need to reboot again to make sure everything works.\nTo run this script as-new, remove the file /root/.d006-wireless-ran"
fi