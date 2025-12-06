# About Hyprzen: Patrik's Hyprland Desktop Setup

## Introduction

Hyprzen is a comprehensive automation repository for setting up a fully customized Hyprland-based desktop environment on Arch Linux. Created by Patrik, this project leverages GNU Stow for dotfile management and includes extensive installation scripts to bootstrap a productivity-focused system with Catppuccin Mocha theming. It assumes a fresh, minimal Arch Linux installation and automates package installation, system configuration, login setup, and dotfile application.

The setup emphasizes Wayland-native tools, development utilities (e.g., Neovim, Lazygit), and a cohesive aesthetic. Key components include Hyprland as the window manager, Ghostty as the terminal, Zsh with Oh My Posh prompts, and productivity apps like Obsidian and Signal.

## Prerequisites

Before running the installation, ensure the following:

- **Operating System**: Clean, minimal Arch Linux installation (vanilla Arch, not derivatives like CachyOS, EndeavourOS, Garuda, or Manjaro). The system must be freshly installed without pre-configured desktop environments (e.g., no Gnome or KDE).
- **Architecture**: x86_64 only.
- **Bootloader**: GRUB must be installed.
- **Filesystem**: Root filesystem must be Btrfs.
- **Security**: Secure Boot must be disabled.
- **User**: Do not run as root; use a regular user account.
- **Hardware**: Basic PC with internet access (required for package downloads).
- **Warnings**: If any preflight checks fail, the setup may be unsupported. Use `gum confirm` to proceed at your own risk.

## Installation Guide

The installation is driven by `install.sh`, which orchestrates the entire process. Run it from the repository root:

```bash
./install.sh
```

Optionally, add `--restart` to reboot after completion:

```bash
./install.sh --restart
```

### Step-by-Step Breakdown

1. **Initial Setup**:
   - Creates `~/bin` directory for custom scripts and repositories.
   - Sources `install/preflight/all.sh` for checks and AUR setup.

2. **Preflight Checks (`install/preflight/`)**:
   - **`all.sh`**: Sources `guard.sh` and runs `yay.sh`.
   - **`guard.sh`**: Validates system compatibility:
     - Confirms vanilla Arch Linux.
     - Ensures not running as root.
     - Checks x86_64 architecture.
     - Verifies Secure Boot is disabled.
     - Ensures no Gnome/KDE desktops are pre-installed.
     - Confirms GRUB is present.
     - Checks root is on Btrfs.
     - Uses `gum confirm` for user acknowledgment of potential issues.
   - **`yay.sh`**: Installs `yay` (AUR helper) if absent, along with dependencies (git, openssl, base-devel). Generates the development package database and permanently enables dev package updates.

3. **Package Installation (`install/packaging/`)**:
   - **`all.sh`**: Executes `system.sh`, `base.sh`, `hyprland.sh`, `desktop.sh`, and `utils.sh` in sequence, installing packages via `pacman`.
   - **`system.sh`**: Installs system-level utilities from `system.packages`:
     - ca-certificates, ca-certificates-mozilla, ca-certificates-utils (SSL/TLS certificates for secure connections).
     - curl, wget (networking tools for downloads).
     - nss (network security services).
     - pacman-contrib (Pacman contributions, e.g., paccache for cache management).
     - plymouth (boot splash screen).
     - reflector (Pacman mirror ranking tool).
   - **`base.sh`**: Installs core system tools from `base.packages`:
     - brightnessctl (screen brightness control).
     - bluetui (Bluetooth TUI interface).
     - cups, cups-browsed, cups-filters, cups-pdf, system-config-printer (printing system).
     - docker, docker-buildx, docker-compose (containerization platform).
     - exfatprogs (exFAT filesystem support).
     - github-cli (GitHub command-line interface).
     - grub-btrfs (GRUB integration with Btrfs snapshots).
     - impala (likely a custom or specific tool; possibly a database utility).
     - imv (image viewer for Wayland).
     - inetutils (basic networking utilities like hostname, ping).
     - iwd (iNet wireless daemon for Wi-Fi).
     - jq (JSON processor for scripting).
     - llvm (compiler infrastructure).
     - man-db (manual pages database).
     - mise (version manager for Node.js, Python, etc.).
     - rustup (Rust toolchain installer).
     - stow (GNU Stow for dotfile symlinks).
     - ufw (uncomplicated firewall).
     - unzip (archive extractor).
     - whois (domain and IP lookup tool).
     - wireless-regdb (wireless regulatory database).
     - wiremix (likely a wireless mixer or custom tool).
     - wl-clipboard (Wayland clipboard utilities).
     - zsh (Z shell).
     - nvim (Neovim text editor).
   - **`hyprland.sh`**: Installs Hyprland ecosystem from `hyprland.packages`:
     - hyprland (Wayland window manager).
     - hyprpicker (color picker utility).
     - hyprland-guiutils (GUI utilities for Hyprland).
     - uwsm (Universal Wayland Session Manager).
     - sddm (Simple Desktop Display Manager).
     - xdg-desktop-portal-gtk, xdg-desktop-portal-hyprland (desktop portals for file dialogs and screen sharing).
   - **`desktop.sh`**: Installs desktop applications from `desktop.packages`:
     - noctalia-shell (custom shell or launcher).
     - ghostty (terminal emulator).
     - grim, slurp (screenshot tools for Wayland).
     - satty (screenshot annotation tool).
     - wayfreeze (screen freeze utility).
     - obsidian (note-taking application).
     - pinta (simple image editor).
     - evince (PDF viewer).
     - mpv (media player).
     - signal-desktop (secure messaging app).
     - spotify (music streaming client).
     - xournalpp (note-taking with handwriting support).
     - localsend (local file sharing tool).
     - libreoffice-fresh (office suite).
   - **`utils.sh`**: Installs CLI utilities from `utils.packages`:
     - bat (cat clone with syntax highlighting).
     - dust (disk usage analyzer, du clone).
     - eza (ls clone with icons and colors).
     - fastfetch (system information fetcher).
     - fd (find clone, faster than find).
     - fzf (fuzzy finder for interactive searches).
     - lazydocker (Docker TUI manager).
     - lazygit (Git TUI interface).
     - plocate (locate clone for file searching).
     - ripgrep (grep clone, fast text search).
     - tldr (simplified man pages).
     - trash-cli (safe file deletion to trash).
     - ttf-jetbrains-mono-nerd (Nerd Font for JetBrains Mono).
     - tzupdate (automatic timezone updater).
     - ufw-docker (UFW rules for Docker containers).
     - zoxide (smarter cd command with frecency).
     - snapper-support (Btrfs snapshot support).
     - btrfs-assistant (GUI for Btrfs management).
     - oh-my-posh (shell prompt customizer).

4. **Login Setup (`install/login/`)**:
   - **`all.sh`**: Runs `plymouth.sh`, `grub.sh`, and `sddm.sh`.
   - **`plymouth.sh`**: Installs Plymouth and the Catppuccin Mocha theme from AUR. Modifies `/etc/mkinitcpio.conf` to add "plymouth" hook before "encrypt" and "filesystems". Updates `/etc/default/grub` to add "splash" to GRUB_CMDLINE_LINUX_DEFAULT. Sets Plymouth theme to Catppuccin Mocha and regenerates initramfs with `mkinitcpio -P`.
   - **`grub.sh`**: Downloads the Catppuccin Mocha GRUB theme from GitHub. Configures `/etc/default/grub` to use the theme, set resolution to 1920x1080, keep GFX payload, default to "Arch Linux, with Linux linux", disable submenu, and disable saving last choice. Regenerates GRUB config with `grub-mkconfig -o /boot/grub/grub.cfg`.
   - **`sddm.sh`**: Creates `/etc/sddm.conf.d/autologin.conf` for autologin with the current user and "hyprland-uwsm" session, sets theme to "breeze". Enables the SDDM service.

5. **Config Application (`install/config/`)**:
   - **`all.sh`**: Runs `make apply` to stow dotfiles, then sources `docker.sh`, `fast-shutdown.sh`, `localdb.sh`, `mise-work.sh`, `network.sh`, and `zsh.sh`.
   - **`docker.sh`**: Configures `/etc/docker/daemon.json` with JSON logging (max-size 10m, max-file 5), DNS resolver, and BIP. Exposes systemd-resolved to Docker network. Enables Docker service, adds the current user to the Docker group, and prevents Docker from blocking boot by masking `docker.service` wait.
   - **`fast-shutdown.sh`**: Sets `DefaultTimeoutStopSec=5s` in `/etc/systemd/system.conf` for faster system shutdowns.
   - **`localdb.sh`**: Runs `sudo updatedb` to update the locate database for file searching.
   - **`mise-work.sh`**: Creates `~/Work` and `~/Work/tries` directories. Adds `.mise.toml` to prepend `./bin` to PATH for projects in `~/Work`, and trusts the config.
   - **`network.sh`**: Enables `iwd.service`. Disables and masks `systemd-networkd-wait-online.service` to prevent boot timeouts.
   - **`zsh.sh`**: Adds Zsh to `/etc/shells`, sets it as the default shell with `usermod`. Verifies Zsh installation, shell setting, and dotfile presence.

6. **Completion**:
   - If `--restart` is used, displays a 10-second countdown and reboots the system.

## Dotfiles Documentation

Dotfiles are managed via GNU Stow in `stow-dotfiles/`. Each subdirectory is symlinked to `~` (home directory) during `make apply`.

- **`fastfetch/`**:
  - `.config/fastfetch/config.jsonc`: Main config for Fastfetch, displaying system info (OS, kernel, uptime, hardware). Includes a backup `config.jsonc.bak` for recovery.
- **`ghostty/`**:
  - `.config/ghostty/config`: Primary config for Ghostty terminal (font settings, keybindings, window behavior).
  - `.config/ghostty/config-dankcolors`: Alternative config with custom color schemes.
  - `.config/ghostty/themes/`: Catppuccin themes (frappe, latte, macchiato, mocha) for consistent theming.
- **`hypr/`**:
  - `.config/hypr/animations.conf`: Defines window animations (e.g., fade, slide).
  - `.config/hypr/autostart.conf`: Lists apps to launch on login (e.g., waybar, dunst notifications).
  - `.config/hypr/decoration.conf`: Configures window decorations (borders, shadows, blur).
  - `.config/hypr/env.conf`: Sets environment variables (e.g., QT_QPA_PLATFORMTHEME, GTK_THEME).
  - `.config/hypr/general.conf`: General Hyprland settings (gaps, layout defaults).
  - `.config/hypr/hyprland.conf`: Main config file, sourcing others for modularity.
  - `.config/hypr/input.conf`: Keyboard and mouse settings (sensitivity, layouts).
  - `.config/hypr/keybinds.conf`: Custom keybindings (e.g., SUPER+Return for terminal, window management shortcuts).
  - `.config/hypr/layouts.conf`: Layout options (dwindle, master stack).
  - `.config/hypr/misc.conf`: Miscellaneous (e.g., disable Hyprland logo, focus behavior).
  - `.config/hypr/monitors.conf`: Monitor configuration (resolution, positioning).
  - `.config/hypr/qs-keybinds.conf`: Quick-switch keybinds for rapid actions.
  - `.config/hypr/variables.conf`: Custom variables for reuse.
  - `.config/hypr/windowrules.conf`: Rules for specific windows (e.g., float certain apps, set opacity).
- **`noctalia/`**:
  - `.config/noctalia/colors.json`: Color scheme for Noctalia shell (likely a custom launcher).
  - `.config/noctalia/settings.json`: General settings for Noctalia (behavior, integrations).
- **`ohmyposh/`**:
  - `.config/ohmyposh/base.json`: Base prompt configuration for Oh My Posh.
  - `.config/ohmyposh/zen.toml`: Zen-themed prompt with custom segments (e.g., git status, time).
- **`zsh/`**:
  - `.zshrc`: Main Zsh config, sourcing modular files.
  - `.config/zsh/zshrc/functions`: Custom shell functions (e.g., aliases, utilities).
  - `.config/zsh/zshrc/init`: Initialization scripts (e.g., plugin loading).
  - `.config/zsh/zshrc/nvim`: Neovim-related aliases and scripts.
  - `.config/zsh/zshrc/school_42`: Configs tailored for 42 School environment.
  - `.config/zsh/zshrc/setup`: Setup scripts for Zsh environment.

- **`bin/screenshot.sh`**: Custom script for taking screenshots, likely integrating grim/slurp for Wayland.

## Usage and Maintenance

- **Dotfile Management**: Use the Makefile:
  - `make apply`: Stow dotfiles.
  - `make clean`: Remove symlinks.
  - `make restart`: Clean and reapply.
- **Updates**: Run `yay` or `pacman -Syu` for package updates. Re-run `make apply` if dotfiles change.
- **Customization**: Edit dotfiles in `stow-dotfiles/` and reapply with `make restart`.
- **Manual Additions**: Install extras like `yay -S niri` or `yay -S noctalia-shell` as noted in README.

## Troubleshooting/FAQ

- **Preflight Failures**: If guard.sh fails (e.g., non-Arch or Secure Boot), fix the issue or proceed with `gum confirm` (unsupported).
- **Boot Issues**: If Plymouth/GRUB themes fail, check `/boot/grub/themes/` and regenerate configs manually.
- **Network Problems**: Ensure iwd is enabled; disable conflicting services.
- **Docker Errors**: Verify user is in Docker group; check daemon.json syntax.
- **Zsh Not Default**: Run `chsh -s /usr/bin/zsh` manually.
- **General**: Check logs with `journalctl` for errors. Re-run scripts individually if needed.

## Appendices

- **Full Package Lists**: See `.packages` files in `install/` for complete lists.
- **Script Snippets**: Refer to `install/` scripts for exact commands (e.g., `pacman -S --needed - < system.packages`).
- **External Links**: Hyprland docs (hyprland.org), Catppuccin themes (github.com/catppuccin), GNU Stow manual.
- **Version Notes**: Assumes latest Arch packages; test on fresh installs.

This setup transforms a minimal Arch install into a polished, productive Hyprland desktop. For issues, refer to the repository or Arch forums.