# Install all desktop packages
mapfile -t packages < <(grep -v '^#' "$INSTALL_PATH/desktop.packages" | grep -v '^$')
sudo yay -S --needed --noconfirm "${packages[@]}"

steam_install() {
  echo "Now pick dependencies matching your graphics card"
  sudo pacman -Syu --noconfirm steam
  setsid gtk-launch steam >/dev/null 2>&1 &
}

steam_install
