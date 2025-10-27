#!/bin/zsh
#

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

set -e  # Exit on error

echo "######################################################################################"
echo "               ${YELLOW}!!  Package Installation / Updates !!${NC}                         "
echo "######################################################################################"

#Updates and upgrades the Arch linux local repositories
sudo pacman -Syu

#Install/Updates packages from a list.
sudo pacman -S - < pkglist_native.txt

#kmonad - change file permissions to run as user when using exec-once command
sudo chmod u+s /usr/bin/kmonad

echo "######################################################################################"
echo "               ${YELLOW}!!  Enabling Syncthing Services !!${NC}                         "
echo "######################################################################################"

#Start syncthing services
sudo systemctl enable --now syncthing@jledesma44.service 

echo "######################################################################################"
echo "               ${YELLOW}!!  Enabling Tailscale Services !!${NC}                         "
echo "######################################################################################"
#Start Tailscaled
sudo systemctl enable --now tailscaled

#Set ssh in tailscaled
sudo tailscale set --ssh
echo "${GREEN}All packages have been installed and or updated${NC}"
