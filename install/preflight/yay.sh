yay_install() {
  sudo pacman -S --needed --noconfirm git openssl base-devel

  if command -v yay &>/dev/null; then
    return 0
  fi

  local original_dir="$(pwd)"
  mkdir -p ~/bin
  cd ~/bin
  git clone https://aur.archlinux.org/yay-bin.git
  cd yay-bin
  makepkg -si
  cd "$original_dir"
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