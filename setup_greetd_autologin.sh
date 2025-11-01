#!/bin/bash

set -euo pipefail

GREETD_CONF="/etc/greetd/config.toml"
HYPRLAND_WRAPPER="/usr/local/bin/hyprland-run"
CURRENT_USER="${USER}"

create_hyprland_wrapper() {
  if [ ! -f "${HYPRLAND_WRAPPER}" ]; then
    cat <<'EOF' | sudo tee "${HYPRLAND_WRAPPER}"
#!/bin/sh
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland
export XDG_CURRENT_DESKTOP=Hyprland
export MOZ_ENABLE_WAYLAND=1
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
exec dbus-run-session Hyprland "$@"
EOF
    sudo chmod +x "${HYPRLAND_WRAPPER}"
  fi
}

configure_greetd() {
  cat <<EOF | sudo tee "${GREETD_CONF}"
[terminal]
vt = 1

[default_session]
command = "agreety --cmd /bin/sh"
user = "greeter"

[initial_session]
command = "${HYPRLAND_WRAPPER}"
user = "${CURRENT_USER}"
EOF
}

create_hyprland_wrapper
configure_greetd

sudo systemctl enable greetd.service

