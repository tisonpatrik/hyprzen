# HyprZen

This repository provides a complete setup for a Hyprland-based desktop environment on Arch Linux, using GNU Stow for dotfiles management.

## Prerequisites

- Clean minimal Arch Linux installation
- Internet connection for package downloads

## Installation

Run the installation script to set up the system:

```bash
./install.sh
```

This will:
- Perform preflight checks and install yay (AUR helper)
- Install system, base, Hyprland, desktop, and utility packages
- Apply dotfiles configuration

Optionally restart the system after installation:

```bash
./install.sh --restart
```

## Usage

After installation, manage dotfiles with:

```bash
make apply    # Apply dotfiles configuration
make clean    # Remove symlinks and clean config files
make restart  # Clean and reapply configuration
```
