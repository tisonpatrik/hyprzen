#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

# Define locations
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export INSTALL_PATH="${SCRIPT_DIR}"


# Install
source "$INSTALL_PATH/preflight/all.sh"
source "$INSTALL_PATH/packaging/all.sh"
# source "$INSTALL_PATH/config/all.sh"
# source "$INSTALL_PATH/login/all.sh"
# source "$INSTALL_PATH/post-install/all.sh"
