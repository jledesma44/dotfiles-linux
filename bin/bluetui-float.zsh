#!/usr/bin/env zsh

# Script to open bluetui in a floating window
# Requires: bluetui, foot (or another terminal), and a compositor that supports floating windows

# Terminal to use (change as needed)
TERMINAL="foot"

# Window size and position
WIDTH=80
HEIGHT=24
X=100
Y=100

# Check if bluetui is installed
if ! command -v bluetui &> /dev/null; then
    echo "Error: bluetui is not installed or not in PATH"
    echo "Install it with: pacman -S bluetui"
    exit 1
fi

# Check if terminal is available
if ! command -v $TERMINAL &> /dev/null; then
    echo "Error: $TERMINAL is not installed or not in PATH"
    echo "Install it with: pacman -S $TERMINAL"
    exit 1
fi

# Launch bluetui in floating window
case $TERMINAL in
    foot)
        $TERMINAL --app-id bluetui-float --window-size-pixels $(($WIDTH*8)),$(($HEIGHT*16)) --title "Bluetooth Manager" bluetui
        ;;
    alacritty)
        $TERMINAL --class bluetui-float --title "Bluetooth Manager" --dimensions $WIDTH $HEIGHT -e bluetui
        ;;
    kitty)
        $TERMINAL --class bluetui-float --title "Bluetooth Manager" --override font_size=12 --override initial_window_width=$(($WIDTH*8)) --override initial_window_height=$(($HEIGHT*16)) bluetui
        ;;
    *)
        # Fallback for other terminals
        $TERMINAL -e bluetui
        ;;
esac