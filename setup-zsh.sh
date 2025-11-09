#!/usr/bin/env bash

# Script to check, install, and switch to zsh on Arch Linux
# Designed to work as part of a dotbot installation process

set -e  # Exit on error

echo "==> Checking for zsh installation..."

# Check if zsh is installed
if ! command -v zsh &> /dev/null; then
    echo "==> zsh not found. Installing zsh..."
    sudo pacman -S --noconfirm zsh
    echo "==> zsh installed successfully!"
else
    echo "==> zsh is already installed."
fi

# Get the path to zsh
ZSH_PATH=$(which zsh)
echo "==> zsh found at: $ZSH_PATH"

# Check if zsh is already the default shell
if [ "$SHELL" != "$ZSH_PATH" ]; then
    echo "==> Changing default shell to zsh..."
    chsh -s "$ZSH_PATH"
    echo "==> Default shell changed to zsh. (Will take effect on next login)"
else
    echo "==> zsh is already the default shell."
fi

echo "==> zsh setup complete!"
