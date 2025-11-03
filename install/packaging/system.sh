# Install all system packages
mapfile -t packages < <(grep -v '^#' "$INSTALL_PATH/system.packages" | grep -v '^$')
sudo pacman -S --noconfirm --needed "${packages[@]}"
