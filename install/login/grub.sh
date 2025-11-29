#!/bin/bash

# Clone catppuccin grub theme repository
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

git clone https://github.com/catppuccin/grub.git "$TEMP_DIR/grub"

# Copy all themes from src to both theme directories
sudo mkdir -p /usr/share/grub/themes
sudo mkdir -p /boot/grub/themes
sudo cp -r "$TEMP_DIR/grub/src"/* /usr/share/grub/themes/
sudo cp -r "$TEMP_DIR/grub/src"/* /boot/grub/themes/

# Modify /etc/default/grub to set GRUB theme
if [ -f /etc/default/grub ]; then
  # Set GRUB_THEME
  if grep -q "^GRUB_THEME=" /etc/default/grub; then
    sudo sed -i 's|^GRUB_THEME=.*|GRUB_THEME="/boot/grub/themes/catppuccin-mocha-grub-theme/theme.txt"|' /etc/default/grub
  else
    echo 'GRUB_THEME="/boot/grub/themes/catppuccin-mocha-grub-theme/theme.txt"' | sudo tee -a /etc/default/grub > /dev/null
  fi

  # Set GRUB_GFXMODE
  if grep -q "^GRUB_GFXMODE=" /etc/default/grub; then
    sudo sed -i 's|^GRUB_GFXMODE=.*|GRUB_GFXMODE=1920x1080|' /etc/default/grub
  else
    echo 'GRUB_GFXMODE=1920x1080' | sudo tee -a /etc/default/grub > /dev/null
  fi

  # Set GRUB_GFXPAYLOAD_LINUX
  if grep -q "^GRUB_GFXPAYLOAD_LINUX=" /etc/default/grub; then
    sudo sed -i 's|^GRUB_GFXPAYLOAD_LINUX=.*|GRUB_GFXPAYLOAD_LINUX=keep|' /etc/default/grub
  else
    echo 'GRUB_GFXPAYLOAD_LINUX=keep' | sudo tee -a /etc/default/grub > /dev/null
  fi

  # Comment out GRUB_TERMINAL_OUTPUT if it exists
  if grep -q "^GRUB_TERMINAL_OUTPUT=" /etc/default/grub; then
    sudo sed -i 's|^GRUB_TERMINAL_OUTPUT=|# GRUB_TERMINAL_OUTPUT=|' /etc/default/grub
  fi

  # Comment out GRUB_TERMINAL if it exists
  if grep -q "^GRUB_TERMINAL=" /etc/default/grub; then
    sudo sed -i 's|^GRUB_TERMINAL=|# GRUB_TERMINAL=|' /etc/default/grub
  fi

  # Set GRUB_DEFAULT to saved (will be set to latest kernel below)
  if grep -q "^GRUB_DEFAULT=" /etc/default/grub; then
    sudo sed -i 's|^GRUB_DEFAULT=.*|GRUB_DEFAULT=saved|' /etc/default/grub
  else
    echo 'GRUB_DEFAULT=saved' | sudo tee -a /etc/default/grub > /dev/null
  fi
fi

# Update grub config
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Set latest (non-LTS) kernel as default
set_latest_kernel_default() {
  # Find latest non-LTS kernel version
  latest_kernel=$(ls -t /boot/vmlinuz-linux* 2>/dev/null | grep -v "lts" | head -1 | xargs basename | sed 's/vmlinuz-//')
  
  if [ -z "$latest_kernel" ]; then
    return
  fi

  # Find the menu entry index for latest kernel in grub.cfg
  # Count menu entries before the latest kernel entry
  entry_num=0
  while IFS= read -r line; do
    if [[ "$line" =~ ^menuentry.*"$latest_kernel" ]]; then
      sudo grub-set-default "$entry_num" 2>/dev/null && return
    fi
    if [[ "$line" =~ ^menuentry ]]; then
      ((entry_num++))
    fi
  done < /boot/grub/grub.cfg
}

set_latest_kernel_default

# Verify theme is applied
echo "Verifying GRUB theme configuration:"
grep -n "theme" /boot/grub/grub.cfg

