#!/usr/bin/env bash

set -euo pipefail

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "Please run this script as root (e.g., using sudo)."
  exit 1
fi

# Define variables
REPO="tohurtv/Blend-os-setup"

#udev rules
mkdir -p /etc/udev/rules.d 
curl -sSL https://raw.githubusercontent.com/$REPO/main/udev-rules/90-amdgpu.rules -o /etc/udev/rules.d/90-amdgpu.rules 
curl -sSL https://raw.githubusercontent.com/$REPO/main/udev-rules/91-kfd.rules -o /etc/udev/rules.d/91-kfd.rules 
curl -sSL https://raw.githubusercontent.com/$REPO/main/udev-rules/30-zram.rules -o /etc/udev/rules.d/30-zram.rules
curl -sSL https://raw.githubusercontent.com/$REPO/main/udev-rules/40-hpet-permissions.rules -o /etc/udev/rules.d/40-hpet-permissions.rules
curl -sSL https://raw.githubusercontent.com/$REPO/main/udev-rules/50-sata.rules -o /etc/udev/rules.d/50-sata.rules
curl -sSL https://raw.githubusercontent.com/$REPO/main/udev-rules/60-ioschedulers.rules -o /etc/udev/rules.d/60-ioschedulers.rules
curl -sSL https://raw.githubusercontent.com/$REPO/main/udev-rules/69-hdparm.rules -o /etc/udev/rules.d/69-hdparm.rules
curl -sSL https://raw.githubusercontent.com/$REPO/main/udev-rules/99-cpu-dma-latency.rules -o /etc/udev/rules.d/99-cpu-dma-latency.rules
curl -sSL https://raw.githubusercontent.com/$REPO/main/udev-rules/60-streamdeck.rules -o /etc/udev/rules.d/60-streamdeck.rules 
curl -sSL https://raw.githubusercontent.com/$REPO/main/udev-rules/60-openrgb.rules -o /usr/lib/udev/rules.d/60-openrgb.rules

#add scipts and binaries to the system
curl -sSL https://raw.githubusercontent.com/$REPO/main/usr/bin/pci-latency -o /usr/bin/pci-latency && chmod +x /usr/bin/pci-latency

#SDDM Wayland conf
mkdir -p /etc/sddm.conf.d 
curl -sSL https://raw.githubusercontent.com/$REPO/main/sddm.conf.d/sddm-wayland.conf -o /etc/sddm.conf.d/10-wayland.conf

#systemd setup
rm /usr/lib/systemd/user/appmenu-gtk-module.service
curl -sSL https://raw.githubusercontent.com/$REPO/main/systemd/user/appmenu-gtk-module.service -o /etc/systemd/user/appmenu-gtk-module.service
curl -sSL https://raw.githubusercontent.com/$REPO/main/systemd/system/lactd.service -o /etc/systemd/system/lactd.service
curl -sSL https://raw.githubusercontent.com/$REPO/main/systemd/system/pci-latency.service -o /etc/systemd/system/pci-latency.service
curl -sSL https://raw.githubusercontent.com/$REPO/main/systemd/zram-generator.conf -o /etc/systemd/zram-generator.conf

#Enbale services
systemctl enable --global appmenu-gtk-module.service
systemctl enable lactd.service
systemctl enable pci-latency.service

#sysctl.d setup
mkdir -p /etc/sysctl.d 
curl -sSL https://raw.githubusercontent.com/$REPO/main/sysctl.d/99-cachyos-settings.conf -o /etc/sysctl.d/99-cachyos-settings.conf

#modprobe.d setup
mkdir -p /etc/modprobe.d 
curl -sSL https://raw.githubusercontent.com/$REPO/main/modprobe.d/blacklist.conf -o /etc/modprobe.d/blacklist.conf

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

#whitesur-gtk-theme
PKGDIR="/tmp/whitesur-gtk-theme-git"
mkdir -p "$PKGDIR"
curl -sSL "https://raw.githubusercontent.com/$REPO/main/PKGBUILDS/whitesur-gtk-theme-git/PKGBUILD" -o "$PKGDIR/PKGBUILD"
paru -U --noconfirm "$PKGDIR/PKGBUILD"

# clean pacman cache
rm -rf /var/cache/pacman

echo "Installation complete."
