# Install all desktop packages
mapfile -t packages < <(grep -v '^#' "$INSTALL_PATH/desktop.packages" | grep -v '^$')
yay -S --needed --noconfirm "${packages[@]}"

enable_multilib() {
  if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo "Enabling multilib repository..."
    echo "" | sudo tee -a /etc/pacman.conf > /dev/null
    echo "[multilib]" | sudo tee -a /etc/pacman.conf > /dev/null
    echo "Include = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf > /dev/null
    sudo pacman -Sy
  else
    echo "Multilib repository already enabled"
  fi
}

setup_locale() {
  if ! grep -q "^en_US.UTF-8 UTF-8" /etc/locale.gen; then
    echo "Setting up en_US.UTF-8 locale..."
    if grep -q "^#en_US.UTF-8 UTF-8" /etc/locale.gen; then
      sudo sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
    else
      echo "en_US.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen > /dev/null
    fi
    sudo locale-gen
  else
    echo "en_US.UTF-8 locale already configured"
  fi
}

detect_gpu_driver() {
  local gpu_vendor=""
  
  if lspci | grep -qi "nvidia"; then
    gpu_vendor="nvidia"
  elif lspci | grep -qi "amd\|ati\|radeon"; then
    gpu_vendor="amd"
  elif lspci | grep -qi "intel"; then
    gpu_vendor="intel"
  fi
  
  echo "$gpu_vendor"
}

steam_install() {
  echo "Setting up Steam..."
  
  # Enable multilib
  enable_multilib
  
  # Setup locale
  setup_locale
  
  # Detect GPU and install appropriate driver
  local gpu=$(detect_gpu_driver)
  echo "Detected GPU vendor: ${gpu:-unknown}"
  
  if [ -n "$gpu" ]; then
    case "$gpu" in
      nvidia)
        echo "Installing NVIDIA 32-bit Vulkan driver..."
        sudo pacman -S --noconfirm --needed lib32-nvidia-utils
        ;;
      amd)
        echo "Installing AMD 32-bit Vulkan driver..."
        sudo pacman -S --noconfirm --needed lib32-mesa lib32-vulkan-radeon
        ;;
      intel)
        echo "Installing Intel 32-bit Vulkan driver..."
        sudo pacman -S --noconfirm --needed lib32-mesa lib32-vulkan-intel
        ;;
    esac
  else
    echo "Warning: Could not detect GPU vendor. You may need to install 32-bit Vulkan driver manually."
    echo "Available options:"
    echo "  - lib32-nvidia-utils (NVIDIA)"
    echo "  - lib32-mesa lib32-vulkan-radeon (AMD)"
    echo "  - lib32-mesa lib32-vulkan-intel (Intel)"
  fi
  
  # Install 32-bit OpenGL driver (required for all GPUs)
  echo "Installing 32-bit OpenGL driver..."
  sudo pacman -S --noconfirm --needed lib32-mesa
  
  # Install Steam
  echo "Installing Steam..."
  sudo pacman -S --noconfirm --needed steam
  
  # Launch Steam
  echo "Launching Steam..."
  setsid gtk-launch steam >/dev/null 2>&1 &
}

steam_install
