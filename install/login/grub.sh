#!/bin/bash

# --- 1. Set variables ---
THEME_DIR="/boot/grub/themes"
THEME_NAME="catppuccin-mocha-grub-theme"
GRUB_CFG="/etc/default/grub"

# --- 2. Install theme ---
# Download only what's needed to /tmp, move it and clean up
if [ ! -d "$THEME_DIR/$THEME_NAME" ]; then
    echo "Downloading theme..."
    git clone --depth 1 https://github.com/catppuccin/grub.git /tmp/catppuccin-grub
    sudo mkdir -p "$THEME_DIR"
    sudo cp -r "/tmp/catppuccin-grub/src/$THEME_NAME" "$THEME_DIR/"
    rm -rf /tmp/catppuccin-grub
else
    echo "Theme already downloaded, skipping download."
fi

# --- 3. Configure GRUB ---
echo "Configuring /etc/default/grub..."

# Backup for safety (if it doesn't exist yet)
if [ ! -f "$GRUB_CFG.bak" ]; then
    sudo cp "$GRUB_CFG" "$GRUB_CFG.bak"
fi

# Function to set value (either replaces existing or adds at the end)
set_opt() {
    local key="$1"
    local value="$2"
    if grep -q "^$key=" "$GRUB_CFG"; then
        sudo sed -i "s|^$key=.*|$key=\"$value\"|" "$GRUB_CFG"
    else
        echo "$key=\"$value\"" | sudo tee -a "$GRUB_CFG" > /dev/null
    fi
}

# A) Comment out lines that break graphical themes
sudo sed -i 's/^GRUB_TERMINAL_OUTPUT=/#&/' "$GRUB_CFG"
sudo sed -i 's/^GRUB_TERMINAL=/#&/' "$GRUB_CFG"

# B) Set theme and resolution
set_opt "GRUB_THEME" "$THEME_DIR/$THEME_NAME/theme.txt"
set_opt "GRUB_GFXMODE" "1920x1080"
set_opt "GRUB_GFXPAYLOAD_LINUX" "keep"

# C) Set default kernel (THIS IS THE CHANGE)
# Set index 0 (on Arch, 0 is always the latest kernel)
set_opt "GRUB_DEFAULT" "Arch Linux, with Linux linux"
# Disable saving last choice (so it doesn't get stuck on LTS if you use it once)
set_opt "GRUB_SAVEDEFAULT" "false"

# D) Disable submenu (so all kernels are visible on the main screen)
# This is optional, but makes it easier to select LTS in case of emergency
set_opt "GRUB_DISABLE_SUBMENU" "y"

# --- 4. Apply changes ---
echo "Generating new grub.cfg..."
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "Done. The latest kernel will now boot by default."