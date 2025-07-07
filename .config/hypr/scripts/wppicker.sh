#!/bin/bash

# === CONFIG ===
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
SYMLINK_PATH="$HOME/.config/hypr/current_wallpaper"

# === BUILD LIST OF FILES ===
mapfile -t FILES < <(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' \) | sort)

# === GET FILE NAMES FOR DISPLAY ===
CHOICES=()
for file in "${FILES[@]}"; do
    CHOICES+=("$(basename "$file")")
done

# === PROMPT WITH ROFI ===
SELECTED_NAME=$(printf '%s\n' "${CHOICES[@]}" | rofi -dmenu -p -show-icons "Select Wallpaper")
[ -z "$SELECTED_NAME" ] && exit 1

# === FIND FULL PATH ===
for file in "${FILES[@]}"; do
    if [[ "$(basename "$file")" == "$SELECTED_NAME" ]]; then
        SELECTED_PATH="$file"
        break
    fi
done

# === SET WALLPAPER ===
matugen image "$SELECTED_PATH"

# === CREATE SYMLINK ===
mkdir -p "$(dirname "$SYMLINK_PATH")"
ln -sf "$SELECTED_PATH" "$SYMLINK_PATH"

