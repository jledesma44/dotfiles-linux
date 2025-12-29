# dotfiles-Linux

dotfiles.jledesma44

These are the dotfiles for my machines running Arch Linux (Omarchy).

## Intructions

1. run pre-install script before running install script. This is to remove old config files.
2. For kmonad to be executed in the background using hyprland you want to chmod kmonad:

   % sudo chmod u+s /usr/bin/kmonad

   then, add yourself to the input wheel group:

   % sudo usermod -aG input jledesma44

3.

## TODO

- Terminal Preferences
- Change shell to zsh
- .zshrc

## Troubleshooting

Sometimes when updating the system in Arch Linux you get a HYPRLAND_SIGNATURE_NOT_SET error when trying to run a services through hyprland. A system update on Arch Linux might update libraries without rebuilding all dependent packages, causing a broken "Stack". The most reliable fix is reinstall the relevant Hyprland packages to ensure all components are built against the same versions of shared libraries.

The fix is to re-install Hyprland and it's associated tools.

$ sudo pacman -S hyprland hyprctl hyprutils xdg-desktop-portal-hyprland --needed

NOTE: check to see what packages of hyprland you installed and re-install only those.

IF that doesn't work then

1. First un-install manually by running this command:

$ sudo pacman -Rns hyprland hyprutils hyprctl xdg-desktop-portal-hyprland

2. and then re-install:

$ sudo pacman -S hyprland hyprutils hyprctl xdg-desktop-portal-hyprland

3. finally reboot:

$ sudo reboot
