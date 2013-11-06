#!/bin/bash
set -e -u

# Color variations to be generated
COLORS="404040 ffffff"

# Check for required commands
COMMANDS="inkscape pngquant convert"
for COMMAND in $COMMANDS; do
    if [ -z $(which $COMMAND) ]; then
        echo "Command '$COMMAND' not found."
        exit 1
    fi
done

BASE="$(dirname $0)"
TMP="$(mktemp /tmp/tmp.XXXXXXXX)"

# Render icon.svg variations.
inkscape \
    --export-dpi=90 \
    --export-png=$TMP.png \
    $BASE/icon.svg > /dev/null

inkscape \
    --export-dpi=180 \
    --export-png=$TMP@2x.png \
    $BASE/icon.svg > /dev/null

echo ""

for COLOR in $COLORS; do
    convert $TMP.png -fill "#$COLOR" -colorize 100,100,100,0 - | pngquant 32 > $BASE/icon-$COLOR.png
    echo -e "\033[01;33m✔ saved $BASE/icon-$COLOR.png"
    convert $TMP@2x.png -fill "#$COLOR" -colorize 100,100,100,0 - | pngquant 32 > $BASE/icon-$COLOR@2x.png
    echo -e "\033[01;33m✔ saved $BASE/icon-$COLOR@2x.png"
done

rm -f $TMP $TMP.png $TMP@2x.png

echo -e "\n\033[00;33mCOMPLETE! Don't forget to update the \`background-size\` property if the sprite size changed\033[0m"
