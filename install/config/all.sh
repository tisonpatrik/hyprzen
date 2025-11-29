#!/bin/bash

# Apply dotfiles configuration using stow
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Applying dotfiles configuration..."
cd "$REPO_ROOT" && make apply

