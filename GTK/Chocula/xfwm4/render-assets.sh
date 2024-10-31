#! /bin/bash

declare -A LINKS=(
    # [link name] = target
    ["bottom-inactive"]="bottom-active"
    ["bottom-left-inactive"]="bottom-left-active"
    ["bottom-right-active"]="bottom-right-inactive"
    ["left-active"]="right-active"
    ["left-inactive"]="right-active"
    ["menu-inactive"]="menu-active"
    ["menu-prelight"]="menu-active"
    ["menu-pressed"]="menu-active"
    ["right-inactive"]="right-active"
)

declare -A DIR_DPI=(
    # [export dir] = png dpi
    ["$PWD"]="96"
    ["Chocula-hdpi/xfwm4"]="144"
    ["Chocula-xhdpi/xfwm4"]="192"
)


for dir in "${!DIR_DPI[@]}"; do
    dpi="${DIR_DPI[$dir]}"

    [[ ! -d $dir ]] && mkdir -p $dir
    [[ ! -f $dir/themerc ]] && cp themerc $dir

    for file in assets/*; do
        name="${file##*/}"
        png="$dir/${name%.*}.png"

        [[ -f $png ]] && rm $png

        printf "Rendering %s.png at %s dpi ... " ${name%.*} $dpi
        inkscape --export-dpi=$dpi --export-filename=$png $file > /dev/null 2>&1
        optipng -o7 --quiet $png
        echo "done"
    done

    for link in "${!LINKS[@]}"; do
        target="${LINKS[$link]}.png"
        ln -sf $target $dir/$link.png
    done
done

