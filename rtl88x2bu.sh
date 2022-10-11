#!/usr/bin/env bash

# SolCol.TomR.me 2022
# https://github.com/solcol/scripts-etc
#
# Actual commands that do stuff stolen from the doc on Teams, sorry Neil xx


if [ "$EUID" -ne 0 ]; then
    echo "This script must be ran as root! Try prefacing your command with 'sudo' :)"
    exit 1
fi

# vars
sleep_time=3
check_file="/root/.d006-wireless-ran"
git_source_location="/usr/src/rtl88x2bu-git"

if [[ ! -f $check_file ]]; then
    echo -e "Looks like this is your first time running this script!\nWe'll need to download some things first...\n\n"
    sleep $sleep_time

    # haven't run the script before, need to update and install stuff 
    echo -e "\n\n\nUpdating Package Repos & Upgrading...\n##########\n\n"
    sleep $sleep_time
    apt update -y && apt upgrade -y

    echo -e "\n\n\nInstalling aircrack-ng, git & dkms...\n##########\n\n"
    sleep $sleep_time
    apt install aircrack-ng dkms git -y
else
    echo -e "Welcome back!\nThis isn't the first time you've run this script: let's get those kernel modules running!\n\n"
    sleep $sleep_time
fi


if [[ ! -d $git_source_location ]]; then
    # doesn't exist, we need to clone it
    echo -e "\n\n\nCloning repository to $git_source_location\n##########\n\n"
    sleep $sleep_time
    git clone https://github.com/RinCat/RTL88x2BU-Linux-Driver.git $git_source_location -v 
fi


if [[ ! -f $check_file ]]; then
    # haven't run the script before, we need to install the kernel module
    echo -e "\n\n\nInstalling RTL88x2BU dynamic kernel module...\n##########\n\n"
    sleep $sleep_time
    sed -i 's/PACKAGE_VERSION="@PKGVER@"/PACKAGE_VERSION="git"/g' $git_source_location/dkms.conf
    dkms add -m rtl88x2bu -v git --verbose

    touch $check_file
    echo -e "\a\n\n##########\n\nOkay, we're done for now!\nPlease reboot and run this script again to finish installing :)"
else
    # we've run the script before, let's install things
    echo -e "\n\n\nRunning dkms autoinstall\n##########\n\n"
    sleep $sleep_time
    dkms autoinstall

    echo -e "\n\n\nEnabling kernel module right now\n##########\n\n"
    sleep $sleep_time
    modprobe 88x2bu

    # \a = beep speaker!!
    echo -e "\a\n\n##########\n\nDone with everything... hopefully! You may need to reboot again to make sure everything works.\nTo run this script as-new, remove the file at $check_file"
fi