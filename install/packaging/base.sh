# Install all base packages
mapfile -t packages < <(grep -v '^#' "$INSTALL_PATH/base.packages" | grep -v '^$')
sudo pacman -S --noconfirm --needed "${packages[@]}"
