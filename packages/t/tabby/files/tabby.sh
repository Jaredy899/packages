#!/usr/bin/env sh
# Launches Tabby with flags specified in $XDG_CONFIG_HOME/tabby-flags.conf

set -e

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
TABBY_FLAGS="--no-sandbox"

if [ -r "${XDG_CONFIG_HOME}/tabby-flags.conf" ]; then
    TABBY_FLAGS="$(cat "${XDG_CONFIG_HOME}/tabby-flags.conf")"
fi

# Tabby's glasstron dependency uses X11; on Wayland sessions run via XWayland.
if [ -n "${WAYLAND_DISPLAY+set}" ] && [ -z "${DISPLAY+set}" ]; then
    export DISPLAY=:0
fi
if [ -z "${TABBY_NO_X11+set}" ]; then
    TABBY_FLAGS="$TABBY_FLAGS --ozone-platform=x11 --disable-gpu-compositing"
fi

# shellcheck disable=SC2086
exec /usr/share/tabby/tabby $TABBY_FLAGS "$@"
