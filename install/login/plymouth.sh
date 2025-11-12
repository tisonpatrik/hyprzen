#!/bin/bash

# Clone catppuccin plymouth theme repository
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

git clone https://github.com/catppuccin/plymouth.git "$TEMP_DIR/plymouth"

# Copy mocha theme to plymouth themes directory
sudo cp -r "$TEMP_DIR/plymouth/themes/catppuccin-mocha" /usr/share/plymouth/themes/

# Set plymouth theme
sudo plymouth-set-default-theme -R catppuccin-mocha