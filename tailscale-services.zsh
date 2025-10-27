#Enabling Tailscale servcies
echo "######################################################################################"
echo "               ${YELLOW}!!  Enabling Tailscale Services !!${NC}                         "
echo "######################################################################################"
#Start Tailscaled
sudo systemctl enable --now tailscaled

#Set ssh in tailscale
sudo tailscale set --ssh
