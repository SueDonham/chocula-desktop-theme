#!/bin/bash

# Destination paths for root vs user installations:
[[ $UID == "0" ]] && DEST="/usr/share" && ROOT=true	|| DEST="$HOME/.local/share"

THEME_DIR=${PWD%/*}
SDDM_DEST="/usr/share/sddm/themes"

declare -A DIRS=(
	["aurorae"]="aurorae/themes/"
	["color-schemes"]="color-schemes/"
	["plasma/desktoptheme"]="plasma/desktoptheme/"
	["kvantum"]="Kvantum/"
	["plasma/look-and-feel"]="plasma/look-and-feel/"
	["$THEME_DIR/GTK"]="themes/"
)

printf "Installing desktop theme ... "

# Copy themes to destinations:
for d in "${!DIRS[@]}"; do
	choc_dest=$DEST/${DIRS[$d]}
	mkdir -p "$choc_dest"
	cp -r "${d}"/* "$choc_dest"
done

# SDDM prompt for non-root installs:
[[ ! $ROOT ]] && read -r -p 'Install SDDM theme (requires root access)? [y|N] ' YN
if [[ ("$YN" == [yY]*) || ($SROOT) ]]; then
	sudo mkdir -p $SDDM_DEST
	sudo cp -r sddm/* $SDDM_DEST
fi

echo "Done"

