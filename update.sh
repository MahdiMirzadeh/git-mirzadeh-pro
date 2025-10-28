#!/bin/sh

OUT_DIR="$HOME/Code/git-mirzadeh-pro/dist/"

REPOS="
$HOME/Code/mirzadeh-pro:My personal website
$HOME/Code/qbittorrent:My qbittorrent themes
$HOME/Code/excalocal:Local Excalidraw server
$HOME/Code/kaveh:A lightweight static site generator written in pure POSIX shell
$HOME/Code/git-mirzadeh-pro:Source code for git.mirzadeh.pro
$HOME/Code/app-grid-wizard:A gnome shell extension that automates application folders
$HOME/Code/getip:Simple shell script to obtain Internal/External IP
$HOME/Code/dumbsh:Your shell is dumb, make it smarter.
$HOME/Code/suckless-patches:My patches for http://suckless.org/
$HOME/Code/slock:Mahdi's build of slock
$HOME/Code/mksh:Mahdi's build of mksh
$HOME/Code/neatvi:Mahdi's build of neatvi
$HOME/Code/dmenu:Mahdi's build of dmenu
$HOME/Code/dwm:Mahdi's build of dwm
$HOME/Code/st:Mahdi's build of st
$HOME/Code/tabbed:Mahdi's build of tabbed
$HOME/Code/surf:Mahdi's build of surf
$HOME/Code/merbe:Mahdi's build of herbe
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
	stagit "$REPO_NAME"
	cp $ASSETS .

	# Use log.html as the default index.html
	cp "log.html" "index.html"
done

stagit-index `echo "$REPOS" | awk -F':' '{print $1}' | sort` > "$OUT_DIR/index.html"
