#!/bin/sh

OUT_DIR="$HOME/Code/git-mirzadeh-pro/dist/"

REPOS="
$HOME/Code/mirzadeh-pro:My personal website
$HOME/Code/qbittorrent:My qbittorrent themes
$HOME/Code/excalocal:Local Excalidraw server with custom handwritten font and advanced instance management
$HOME/Code/git-mirzadeh-pro:source code for git.mirzadeh.pro
"

ASSETS="
$HOME/Code/git-mirzadeh-pro/style.css
$HOME/Code/git-mirzadeh-pro/logo.png
$HOME/Code/git-mirzadeh-pro/favicon.png
"

# Copy assets
[ -d "$OUT_DIR" ] || mkdir -p "$OUT_DIR"
cd "$OUT_DIR"
cp $ASSETS .

printf "$REPOS" | \
while read -r REPO; do
	# Ignore empty lines
	[ "$REPO" ] || continue

	# Extract repo's name and description
	REPO_NAME="$(printf "$REPO" | cut -d ':' -f 1)"
	REPO_DESC="$(printf "$REPO" | cut -d ':' -f 2)"

	# Adding metadata to the respository
	echo "Mahdi Mirzadeh" > "$REPO_NAME/.git/owner"
	echo "$REPO_DESC" > "$REPO_NAME/.git/description"
	echo "https://github.com/MahdiMirzadeh/${REPO_NAME##*/}.git" \
		> "$REPO_NAME/.git/url"

	# Create git directories in the dist directory
	DIST="$OUT_DIR/${REPO_NAME##*/}"
	[ -d "$DIST" ] || mkdir -p "$DIST"

	# Generate the git-mirzadeh-pro html for the $DIST/$REPO
	cd "$DIST"
	git-mirzadeh-pro "$REPO_NAME"
	cp $ASSETS .
done

git-mirzadeh-pro-index `echo "$REPOS" | awk -F':' '{print $1}'` > "$OUT_DIR/index.html"
