#!/bin/bash

# --- 1. Nastavení proměnných ---
THEME_DIR="/boot/grub/themes"
THEME_NAME="catppuccin-mocha-grub-theme"
GRUB_CFG="/etc/default/grub"

# --- 2. Instalace tématu ---
# Stáhneme jen to potřebné do /tmp, přesuneme a uklidíme
git clone --depth 1 https://github.com/catppuccin/grub.git /tmp/catppuccin-grub
sudo mkdir -p "$THEME_DIR"
sudo cp -r "/tmp/catppuccin-grub/src/$THEME_NAME" "$THEME_DIR/"
rm -rf /tmp/catppuccin-grub

# --- 3. Konfigurace GRUBu ---
echo "Konfiguruji /etc/default/grub..."

# Záloha pro jistotu
sudo cp "$GRUB_CFG" "$GRUB_CFG.bak"

# Funkce pro nastavení hodnoty (buď nahradí existující, nebo přidá na konec)
set_opt() {
    local key="$1"
    local value="$2"
    if grep -q "^$key=" "$GRUB_CFG"; then
        sudo sed -i "s|^$key=.*|$key=\"$value\"|" "$GRUB_CFG"
    else
        echo "$key=\"$value\"" | sudo tee -a "$GRUB_CFG" > /dev/null
    fi
}

# A) Zakomentování řádků, které rozbíjí grafická témata (důležité!)
sudo sed -i 's/^GRUB_TERMINAL_OUTPUT=/#&/' "$GRUB_CFG"
sudo sed -i 's/^GRUB_TERMINAL=/#&/' "$GRUB_CFG"

# B) Nastavení tématu a rozlišení
set_opt "GRUB_THEME" "$THEME_DIR/$THEME_NAME/theme.txt"
set_opt "GRUB_GFXMODE" "1920x1080"
set_opt "GRUB_GFXPAYLOAD_LINUX" "keep"

# C) Nastavení defaultního kernelu
# 'saved' + 'GRUB_SAVEDEFAULT' zajistí, že si GRUB pamatuje vaši poslední volbu.
# Pokud nic nezvolíte, bere ten první (což je na Archu vždy ten nejnovější kernel).
set_opt "GRUB_DEFAULT" "saved"
set_opt "GRUB_SAVEDEFAULT" "true"

# --- 4. Aplikace změn ---
echo "Generuji nový grub.cfg..."
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "Hotovo. Téma je aktivní."