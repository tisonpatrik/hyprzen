yay_install() {
  sudo pacman -S --needed --noconfirm base-devel

  if command -v yay &>/dev/null; then
    return 0
  fi

  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
  cd ~
}

yay_install

# First Use
# Development packages upgrade
# Use yay -Y --gendb to generate a development package database for *-git packages that were installed without yay. This command should only be run once.
yay -Y --gendb

# yay -Syu --devel will then check for development package updates
yay -Syu --devel

# Use yay -Y --devel --save to make development package updates permanently enabled (yay and yay -Syu will then always check dev packages)
yay -Y --devel --save