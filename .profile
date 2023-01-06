#!/bin/sh

export PATH="$HOME/.local/bin:$HOME/.local/share/npm/bin:$HOME/.local/share/flatpak/exports/bin:$PATH"

export VDPAU_DRIVER=radeonsi
export LIBVA_DRIVER_NAME=radeonsi

export RUSTFLAGS="-C link-arg=-fuse-ld=lld"

export FZF_DEFAULT_COMMAND="rg --files"

export ANDROID_PREFS_ROOT=/mnt/storage/Android/root
export GRADLE_USER_HOME=/mnt/storage/Android/gradle

export HISTSIZE=10000

#if [ "$XDG_SESSION_TYPE" = "wayland" ] ; then
	# https://github.com/swaywm/sway/issues/595
	export _JAVA_AWT_WM_NONREPARENTING=1
	export MOZ_ENABLE_WAYLAND=1
	export MOZ_DBUS_REMOTE=1

    #export QT_QPA_PLATFORM=wayland-egl
    export CLUTTER_BACKEND=wayland
    export ECORE_EVAS_ENGINE=wayland-egl
    export ELM_ENGINE=wayland_egl
    export NO_AT_BRIDGE=1

    export QT_QPA_PLATFORMTHEME=qt5ct
    export QT_STYLE_OVERRIDE=adwaita-dark
#fi
