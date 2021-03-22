#!/bin/sh

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

#if [ "$XDG_SESSION_TYPE" = "wayland" ] ; then
	# https://github.com/swaywm/sway/issues/595
	export _JAVA_AWT_WM_NONREPARENTING=1
	export MOZ_ENABLE_WAYLAND=1
	export MOZ_DBUS_REMOTE=1
#fi
