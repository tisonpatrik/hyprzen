install_base_packages() {
  mapfile -t packages < <(grep -v '^#' "$INSTALL_PATH/base.packages" | grep -v '^$')
  sudo pacman -Syu --noconfirm
  sudo pacman -S --noconfirm --needed "${packages[@]}"
}

setup_system_trust() {
  sudo timedatectl set-ntp true
  sudo update-ca-trust
  sudo pacman-key --init
  sudo pacman-key --populate archlinux
}

configure_mirrorlist() {
  sudo systemctl enable --now reflector.timer
  sudo reflector \
    --protocol https \
    --latest 20 \
    --sort rate \
    --download-timeout 20 \
    --save /etc/pacman.d/mirrorlist
}

enable_package_cache() {
  ensure_pkg "pacman-contrib"
  sudo systemctl enable --now paccache.timer
  systemctl list-timers | grep -E "paccache|reflector" || true
}




install_base_packages
setup_system_trust
configure_mirrorlist
sudo pacman -Syyu --noconfirm
enable_package_cache
