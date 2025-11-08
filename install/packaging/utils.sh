# Install all utils packages
mapfile -t packages < <(grep -v '^#' "$INSTALL_PATH/utils.packages" | grep -v '^$')
sudo yay -S --needed --noconfirm "${packages[@]}"

auto_cpufreq_install() {
  yay -S --needed --noconfirm auto-cpufreq
  sudo systemctl enable --now auto-cpufreq
}
auto_cpufreq_install