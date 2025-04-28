#!/usr/bin/env bash

set -euo pipefail

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "Please run this script as root (e.g., using sudo)."
  exit 1
fi

# Define variables
REPO_URL="https://github.com/tohurtv/Blend-os-setup"
TMP_DIR=$(mktemp -d)

# Cleanup function to remove temporary directory
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

# Clone the repository
echo "Cloning repository..."
git clone --depth 1 "$REPO_URL" "$TMP_DIR"

# Define source and destination directories
declare -A DIRS=(
  ["modprobe.d"]="/etc/modprobe.d"
  ["sddm.conf.d"]="/etc/sddm.conf.d"
  ["sysctl.d"]="/etc/sysctl.d"
  ["systemd"]="/etc/systemd"
  ["udev-rules"]="/etc/udev/rules.d"
)

# Install configuration files
for src in "${!DIRS[@]}"; do
  src_path="$TMP_DIR/etc/$src"
  dest_path="${DIRS[$src]}"
  if [[ -d "$src_path" ]]; then
    echo "Installing $src to $dest_path..."
    mkdir -p "$dest_path"
    cp -r "$src_path/." "$dest_path/"
  else
    echo "Directory $src_path does not exist. Skipping."
  fi
done

echo "Installation complete."
