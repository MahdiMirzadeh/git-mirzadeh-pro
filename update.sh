#!/bin/sh

OUT_DIR="$HOME/Code/stagit/dist/"

REPOS="
$HOME/Code/mirzadeh-pro
$HOME/Code/qbittorrent
$HOME/Code/excalocal
$HOME/Code/stagit
"

ASSETS="
$HOME/Code/stagit/style.css
$HOME/Code/stagit/logo.png
$HOME/Code/stagit/favicon.png
"

# Copy assets
[ -d "$OUT_DIR" ] || mkdir -p "$OUT_DIR"
cd "$OUT_DIR"
cp $ASSETS .

for REPO in $REPOS; do
	# Ignore empty lines
	[ "$REPO" ] || continue

	# Create git directories in the dist directory
	DIST="$OUT_DIR/${REPO##*/}"
	[ -d "$DIST" ] || mkdir -p "$DIST"

	# Generate the stagit html for the $DIST/$REPO
	cd "$DIST"
	stagit "$REPO"
	cp $ASSETS .
done

stagit-index $REPOS > "$OUT_DIR/index.html"
