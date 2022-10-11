#!/usr/bin/env bash
 
if [ "$EUID" -ne 0 ]; then
    echo "This script must be ran as root! Try prefacing your command with 'sudo' :)"
    exit 1
fi


# Stolen from the doc on Teams, sorry Neil xx

echo -e "\n\n##########\n\nUpdating Package Repos & Upgrading"
apt update -y && apt upgrade -y

echo -e "\n\n##########\n\nInstalling aircrack-ng, git & dksm"
apt install aircrack-ng dkms git -y

echo -e "\n\n##########\n\nCloning repository to /usr/src/rtl88x2bu-git"
rm -rfv /usr/src/rtl88x2bu-git # remove if it already exists
git clone https://github.com/RinCat/RTL88x2BU-Linux-Driver.git /usr/src/rtl88x2bu-git -v 

echo -e "\n\n##########\n\nInstalling RTL88x2BU dynamic kernel module"
sed -i 's/PACKAGE_VERSION="@PKGVER@"/PACKAGE_VERSION="git"/g' /usr/src/rtl88x2bu-git/dkms.conf
dkms add -m rtl88x2bu -v git

# \a = beep speaker!!
# \n = linebreak hopefully
echo -e "\a\n\n##########\n\nDone with everything (hopefully)! \nYou must reboot your system and run 'dkms autoinstall' to complete install.\nGood Luck :)"