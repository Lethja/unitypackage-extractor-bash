#!/bin/sh

# Check enough information was given to extract a Unity package
if [ -z "$1" ]; then printf '%s: file.unitypackage (path)\n' "$0"; exit 1; fi
DIRNAME="${2:-${1%.*}}"

# Set script to stop immediately if a command fails
set -e

# Create the folders and extract the Unity package
mkdir -p "$DIRNAME/tree" "$DIRNAME/guid"
printf '\nExtracting '\''%s'\'' to '\''%s'\''... ' "$1" "$DIRNAME/guid"
tar -xf "$1" -C "$DIRNAME/guid"

printf 'OK\n'
printf 'Rebuilding file hierarchy in '\''%s'\''... ' "$DIRNAME/tree"

# Rebuild tree hierarchy
find "$DIRNAME/guid" -type f -name pathname | while read -r pathname_file; do
    guid_dir=$(dirname "$pathname_file")
    asset_file="$guid_dir/asset"
    [ -f "$asset_file" ] || continue

    # Create path
    unity_path=$(cat "$pathname_file")
    target_dir="$DIRNAME/tree/$(dirname "$unity_path")"
    mkdir -p "$target_dir"

    # Create relative symbolic link
    rel_path=$(realpath --relative-to="$target_dir" "$asset_file")
    ln -sf "$rel_path" "$target_dir/$(basename "$unity_path")"
done

printf 'OK\n'
printf '\nPackage '\''%s'\'' has been successfully reconstructed in '\''%s'\''.\n' "$1" "$DIRNAME/tree"
