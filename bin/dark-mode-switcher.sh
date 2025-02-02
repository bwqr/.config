set -eo pipefail

DARK=('prefer-dark' 'Graphite-Dark' '/mnt/gentoo/home/fmk/projects/tmp/base16/base16-schemes/onedark.yaml' '~/Pictures/wallpapers/pexels-pixabay-65924.jpg')
LIGHT=('prefer-light' 'Graphite-Light' '/mnt/gentoo/home/fmk/projects/tmp/base16/base16-schemes/gruvbox-light-soft.yaml' '~/Pictures/wallpapers/joshua-sortino-xZqr8WtYEJ0-unsplash.jpg')

COLOR_SCHEME=$(gsettings get org.gnome.desktop.interface color-scheme)
BUILDER=/mnt/gentoo/home/fmk/projects/tmp/base16/builder/target/release/builder

template_path () {
    echo "/mnt/gentoo/home/fmk/projects/tmp/base16/base16-templates/$1/templates"
}

if [ "$1" == "" ]; then

    if [ "$COLOR_SCHEME" = "'prefer-dark'" ]; then
        echo -e "󰖔\nDark Mode"
    else
        echo -e "\nLight Mode"
    fi

    exit 0
fi

if [ "$1" != "toggle" ]; then
    echo "Unexpected argument $1. Expected argument was 'toggle'"
    exit -1
fi

MODE=( "${DARK[@]}" )
if [ "$COLOR_SCHEME" = "'prefer-dark'" ]; then
    MODE=( "${LIGHT[@]}" )
fi

# GTK
echo -e "$($BUILDER ${MODE[2]} $(template_path gtk-flatcolor) gtk-2)" > ~/.themes/FlatColor/colors2
echo -e "$($BUILDER ${MODE[2]} $(template_path gtk-flatcolor) gtk-3)" > ~/.themes/FlatColor/colors3

# Waybar
# This should be before gsettings since waybar get notification about color-scheme and reapplies styles
echo -e "$($BUILDER ${MODE[2]} $(template_path waybar) default)" > ~/.config/waybar/theme.css

# GTK
gsettings set org.gnome.desktop.interface gtk-theme "${MODE[1]}"
gsettings set org.gnome.desktop.interface color-scheme "${MODE[0]}"

# Alacritty
echo -e "$($BUILDER ${MODE[2]} $(template_path alacritty) default)" > ~/.config/alacritty/theme.toml

# NeoVim
echo -e "$($BUILDER ${MODE[2]} $(template_path vim) default)" > ~/.config/nvim/colors/fmkhome.vim

# SwayNC
echo -e "$($BUILDER ${MODE[2]} $(template_path waybar) default)" > ~/.config/swaync/theme.css
swaync-client --reload-css

# Sway
echo -e "output * bg '${MODE[3]}' fill" > ~/.config/sway/theme.config
echo -e "$($BUILDER ${MODE[2]} $(template_path sway) colors)" >> ~/.config/sway/theme.config

swaymsg output '*' bg "${MODE[3]}" fill

# Load the colors into shell environment to update the sway colors without reloading it
eval "$($BUILDER ${MODE[2]} $(template_path shell-var) default)"

swaymsg client.focused          "$base0D $base0D $base00 $base0D $base0D" && \
swaymsg client.focused_inactive "$base01 $base01 $base05 $base03 $base01" && \
swaymsg client.unfocused        "$base01 $base00 $base05 $base01 $base01" && \
swaymsg client.urgent           "$base08 $base08 $base00 $base08 $base08"
