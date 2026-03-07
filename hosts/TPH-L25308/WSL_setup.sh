#!/bin/bash

# Exit immediately if a command fails
set -e
# Treat unset variables as errors
set -u
# Ensure pipe commands return non-zero if any component fails
set -o pipefail

echo "Setting up Distrobox on Ubuntu WSL ..."

sudo add-apt-repository ppa:michel-slm/distrobox && \
sudo apt update && \
sudo apt install podman distrobox flatpak


echo "Setting up SubGIDs/SubUIDs ..."

sudo usermod --add-subgids 10000-75535 "$USER" && \
sudo usermod --add-subuids 10000-75535 "$USER" && \
podman system migrate

echo "Setting up SubGIDs/SubUIDs ... done"

echo "Ensuring Wayland window decorations are used ..."
echo "\nln -sf /mnt/wslg/runtime-dir/wayland-0* /run/user/1000/" >> "$HOME/.bashrc"
echo "Ensuring Wayland window decorations are used ... done"

echo "Creating Distrobox assemble file ..."
cat << EOF > RStudio_Fedora.ini
[fedora]
image=registry.fedoraproject.org/fedora-toolbox:42
pull=true
entry=false
pre_init_hooks=sudo dnf --assumeyes copr enable iucar/rstudio;
init_hooks=sudo chown -R $USER:$USER $HOME/;
additional_packages="rstudio-desktop R-devel"
volume="/mnt:/mnt"
home=~/fedora_home
replace=true
exported_apps="rstudio"
EOF
echo "Creating Distrobox assemble file ... done"

sudo systemctl enable podman.socket
echo "Setting up Distrobox on Ubuntu WSL ... done"
