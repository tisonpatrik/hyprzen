#!/bin/bash

# Apply dotfiles configuration using stow
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

cd "$REPO_ROOT" && make apply
source "$SCRIPT_DIR/docker.sh"
source "$SCRIPT_DIR/fast-shutdown.sh"
source "$SCRIPT_DIR/localdb.sh"
source "$SCRIPT_DIR/zsh.sh"