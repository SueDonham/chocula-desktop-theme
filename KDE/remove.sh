#!/bin/bash

# Destination paths for root vs user removals:
[[ $UID == "0" ]] && ROOT=true && DEST="/usr/share" || DEST="$HOME/.local/share"

COLORS=$DEST/color-schemes/Chocula.colors
SDDM_DIR=/usr/share/sddm/themes/Chocula

DIRS=(
	"aurorae/themes/Chocula"
	"plasma/desktoptheme/Chocula"
	"plasma/desktoptheme/Chocula-Solid"
	"Kvantum/Chocula"
	"Kvantum/Chocula-Solid"
	"plasma/look-and-feel/Chocula"
	"themes/Chocula"
)

printf "Removing desktop theme ... "

# Remove theme dirs:
for d in "${!DIRS[@]}"; do
	choc_dir="$DEST/${DIRS[$d]}"
	[[ -d $choc_dir ]] &&	rm -r "$choc_dir"
done

[[ -f $COLORS ]] && rm "$COLORS"	# Remove color scheme


# SDDM removal prompt for non-root users:
if [[ -d $SDDM_DIR ]]; then
	[[ ! $ROOT ]] && read -r -p 'Removing SDDM theme requires root access. Continue? [y|N] ' YN
	[[ ("$YN" == [yY]*) || ( $ROOT ) ]] && sudo rm -r $SDDM_DIR
fi

echo "Done"

