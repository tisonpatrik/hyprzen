# Install all hyprland packages
mapfile -t packages < <(grep -v '^#' "$INSTALL_PATH/hyprland.packages" | grep -v '^$')
sudo pacman -S --noconfirm --needed "${packages[@]}"
