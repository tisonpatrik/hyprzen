#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

# Define locations
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export INSTALL_PATH="${SCRIPT_DIR}/install"

# Create ~/bin directory for repositories and scripts
mkdir -p ~/bin

# Install
source "$INSTALL_PATH/preflight/all.sh"
source "$INSTALL_PATH/packaging/all.sh"
source "$INSTALL_PATH/login/all.sh"

# Apply configuration
source "$INSTALL_PATH/config/all.sh"

# Optional restart
if [ "${1:-}" = "--restart" ]; then
  echo "Restarting system in 10 seconds... (Ctrl+C to cancel)"
  sleep 10
  sudo reboot
fi
