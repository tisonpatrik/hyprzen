# Install all utils packages
mapfile -t packages < <(grep -v '^#' "$INSTALL_PATH/utils.packages" | grep -v '^$')
sudo yay -S --needed --noconfirm "${packages[@]}"

