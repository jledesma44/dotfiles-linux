#!/bin/zsh

# Script to check for and install tmux plugin manager (TPM) on Linux

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "######################################################################################"
echo "                  ${YELLOW}!! TMUX TPM SETUP !!${NC}                                 "
echo "######################################################################################"

# TPM installation directory
TPM_DIR="$HOME/.tmux/plugins/tpm"

# Check if TPM is already installed
if [ -d "$TPM_DIR" ]; then
    echo "✅ ${GREEN}tmux plugin manager (TPM) is already installed at $TPM_DIR${NC}"
    echo "🔄 ${GREEN}Skipping installation${NC}"
    exit 0
fi

echo "❌ tmux plugin manager (TPM) not found"
echo "📦 Installing TPM..."

# Create the plugins directory if it doesn't exist
mkdir -p "$HOME/.tmux/plugins"

# Clone TPM repository
if git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"; then
    echo "✅ TPM successfully installed at $TPM_DIR"
    echo ""
    echo "📋 Next steps:"
    echo "1. Add this line to your ~/.tmux.conf file:"
    echo "   run '~/.tmux/plugins/tpm/tpm'"
    echo ""
    echo "2. Reload tmux config:"
    echo "   tmux source ~/.tmux.conf"
    echo ""
    echo "3. Install plugins with: prefix + I (capital i)"
else
    echo "❌ Failed to clone TPM repository"
    echo "Please check your internet connection and try again"
    exit 1
fi
