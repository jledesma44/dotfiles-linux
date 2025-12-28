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

#Install/Update packages from a list Pacman
sudo pacman -S --noconfirm --needed - < pkglist_pacman.txt

#Add any newly installed packages to pkglist_native.txt file
pacman -Qqe > pkglist_pacman.txt

#Install/Update packages from a list from the AUR
sudo yay -S --needed - < pkglist_yay.txt

#kmonad - change file permissions to run as user when using exec-once command
sudo chmod u+s /usr/bin/kmonad

echo "${GREEN}All packages have been installed and or updated${NC}"
