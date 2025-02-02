export PATH="$HOME/.local/bin:$HOME/.local/share/npm/bin:$HOME/.local/share/flatpak/exports/bin:/var/lib/flatpak/exports/bin/:$PATH"

export VDPAU_DRIVER=radeonsi
export LIBVA_DRIVER_NAME=radeonsi

export FZF_DEFAULT_COMMAND="rg --files"

export HISTSIZE=10000

# https://github.com/swaywm/sway/issues/595
export _JAVA_AWT_WM_NONREPARENTING=1
export MOZ_ENABLE_WAYLAND=1
export MOZ_DBUS_REMOTE=1

export QT_QPA_PLATFORMTHEME=qt5ct
export QT_STYLE_OVERRIDE=adwaita-dark
. "$HOME/.cargo/env"
