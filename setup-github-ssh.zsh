#!/bin/zsh

# GitHub SSH Key Setup Script for macOS
# This script creates SSH keys for GitHub and configures your system


# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

set -e  # Exit on error

echo "######################################################################################"
echo "                   ${YELLOW}!!  GITHUB SSH KEY SETUP !!${NC}                         "
echo "######################################################################################"
echo ""
echo "This script will:"
echo "  • Generate a new SSH key pair for GitHub"
echo "  • Configure ssh-agent and macOS keychain"
echo "  • Update your ~/.ssh/config file"
echo "  • Optionally convert git repos from HTTPS to SSH"
echo ""
echo -n "${BLUE}Do you want to proceed with SSH key setup for github? (y/n): ${NC}"
read proceed

if [[ ! "$proceed" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Setup cancelled. No changes were made."
    echo ""
    exit 0
fi

echo ""
echo "Proceeding with setup..."
echo ""

# Get user's email for SSH key
echo -n "Enter your GitHub email address: "
read email

if [ -z "$email" ]; then
    echo "Error: Email address is required"
    exit 1
fi

# Get hostname
hostname=$(hostname -s)

# Create key filename with gh prefix and hostname
key_name="gh_${hostname}"
key_path="$HOME/.ssh/${key_name}"

echo ""
echo "Creating SSH key: ${key_name}"
echo ""

# Step 1: Create SSH keys
ssh-keygen -t ed25519 -C "$email" -f "$key_path" -N ""

echo ""
echo "✓ SSH keys created successfully!"
echo ""

# Step 2: Keys are already renamed with gh prefix and hostname

# Step 3: Start ssh-agent and add key
echo "Starting ssh-agent and adding key..."
eval "$(ssh-agent -s)"

# Step 4: Create ~/.ssh/config if it doesn't exist
ssh_config="$HOME/.ssh/config"
if [ ! -f "$ssh_config" ]; then
    echo "Creating ~/.ssh/config file..."
    touch "$ssh_config"
    chmod 600 "$ssh_config"
fi

echo ""
echo "Updating SSH config..."

# Check if GitHub config already exists
if grep -q "Host github.com" "$ssh_config"; then
    echo "GitHub configuration already exists in ~/.ssh/config"
    echo "Please manually update it if needed."
else
    cat >> "$ssh_config" << EOF

# GitHub Configuration
Host github.com
    AddKeysToAgent yes
    IdentityFile $key_path

EOF
    echo "✓ Added GitHub configuration to ~/.ssh/config"
fi

# Add key to ssh-agent with keychain
#ssh-add --apple-use-keychain "$key_path"

echo ""
echo "✓ SSH key added to ssh-agent!"
echo ""

# Step 6: Display public key
echo "==================================="
echo "YOUR PUBLIC SSH KEY:"
echo "==================================="
echo ""
cat "${key_path}.pub"
echo ""
echo "==================================="
echo ""

# Copy to clipboard if pbcopy is available
if command -v xclip &> /dev/null; then
    cat "${key_path}.pub" | xclip
    echo "✓ Public key copied to clipboard!"
    echo ""
fi

# Step 7: Instructions for adding key to GitHub
echo "========================================================"
echo "${GREEN}NEXT STEPS: Instructions to add pub key to github${NC}"
echo "========================================================"
echo ""
echo "1. Add your SSH key to GitHub:"
echo "   - Go to: https://github.com/settings/keys"
echo "   - Click 'New SSH key'"
echo "   - Title: ${hostname} (or any name you prefer)"
echo "   - Key: Paste the public key shown above (already in clipboard)"
echo "   - Click 'Add SSH key'"
echo ""
echo "2. Test your connection:"
echo "   ssh -T git@github.com"
echo ""
echo "3. You should see: 'Hi <username>! You've successfully authenticated...'"
echo ""

# Step 8: Change dotfiles repo from HTTPS to SSH
echo -n "${GREEN}Do you want to convert your current git repository from HTTPS to SSH? (y/n): ${NC}"
read convert_repo

if [[ "$convert_repo" =~ ^[Yy]$ ]]; then
    echo ""
    echo -n "Enter the path to your git repository (or press Enter for current directory): "
    read repo_path
    
    if [ -z "$repo_path" ]; then
        repo_path="."
    fi
    
    if [ -d "$repo_path/.git" ]; then
        cd "$repo_path"
        current_url=$(git remote get-url origin 2>/dev/null || echo "")
        
        if [ -n "$current_url" ]; then
            echo "Current remote URL: $current_url"
            
            # Extract username and repo name from HTTPS URL
            if [[ "$current_url" =~ https://github.com/([^/]+)/([^/]+)(\.git)?$ ]]; then
                username="${match[1]}"
                repo="${match[2]}"
                repo="${repo%.git}"  # Remove .git if present
                
                new_url="git@github.com:${username}/${repo}.git"
                git remote set-url origin "$new_url"
                
                echo "✓ Changed remote URL to: $new_url"
                echo ""
                echo "Test the connection with: git fetch"
            else
                echo "Could not parse GitHub HTTPS URL. Please manually change it with:"
                echo "git remote set-url origin git@github.com:USERNAME/REPO.git"
            fi
        else
            echo "No remote 'origin' found in this repository."
        fi
    else
        echo "Not a git repository: $repo_path"
    fi
fi

echo ""
echo "==================================="
echo "Setup Complete!"
echo "==================================="
echo ""
echo "Summary of files created/modified:"
echo "  - Private key: $key_path"
echo "  - Public key: ${key_path}.pub"
echo "  - SSH config: $ssh_config"
echo ""
