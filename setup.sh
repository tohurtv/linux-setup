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

#Enbale services
systemctl enable lactd.service

# rm .desktops
rm /usr/share/applications/assistant.desktop 
rm /usr/share/applications/avahi-discover.desktop 
rm /usr/share/applications/bvnc.desktop
rm /usr/share/applications/electron*.desktop 
rm /usr/share/applications/*-openjdk.desktop 
rm /usr/share/applications/linguist.desktop 
rm /usr/share/applications/lstopo.desktop 
rm /usr/share/applications/qdbusviewer.desktop 
rm /usr/share/applications/qv4l2.desktop 
rm /usr/share/applications/qvidcap.desktop 
rm /usr/share/applications/stoken-*.desktop 
rm /usr/share/applications/org.kde.kuserfeedback-console.desktop 
rm /usr/share/applications/bssh.desktop 
rm /../usr/share/applications/cups.desktop 
rm /usr/share/applications/designer.desktop

# create any needed symlinks
ln -s /usr/lib/libopenh264.so /usr/lib/libopenh264.so.7

echo "Installation complete."
