
echo "######################################################################################"
echo "               ${YELLOW}!!  Enabling Syncthing Services !!${NC}                      "
echo "######################################################################################"

#Start syncthing services
sudo systemctl enable --now syncthing@jledesma44.service 

