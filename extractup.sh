#!/bin/bash

# Check enough information was given to extract a Unity package
if [ -z "$1" ]; then echo "$0: file.unitypackage (path)"; exit 1; fi
DIRNAME="${2:-${1%.*}}"

# Set script to stop immediatly if a command fails
set -e

# Create the folders and extract the Unity package
mkdir -p "$DIRNAME"/{tree,guid}
echo -en "\nExtracting '$1' to '$DIRNAME/guid'... "
tar -xf "$1" -C "$DIRNAME/guid"

echo "OK"
echo -n "Rebuilding file hierarchy in '$DIRNAME/tree'... "

# Rebuild tree heirachy
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

echo "OK"

echo -e "\nPackage '$1' has been successfully reconstructed in '$DIRNAME/tree'."
