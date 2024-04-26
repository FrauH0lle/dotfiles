#!/usr/bin/env bash

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"/lib.sh

# Prepare OS for deployment.
# - Configure local repository
# - Create directories

case "$DOD_DISTRO" in
    gentoo)
        # Add GURU overlay
        # Make sure eselect-repository is installed
        if ! equery l app-eselect/eselect-repository > /dev/null; then
            dod::log-info "Installing app-eselect/eselect-repository"
            sudo emerge --oneshot --verbose app-eselect/eselect-repository || exit 1
        fi

        if ! eselect repository list -i | grep "guru" > /dev/null; then
           dod::log-info "Adding GURU overlay"
           sudo eselect repository enable guru || exit 1
           sudo emaint sync -r guru || exit 1
        fi
        ;;
    ubuntu)
        # Make sure equivs and dpkg-dev are installed
        if dod::check_uncallable equivs-build; then
            sudo apt-get update
            sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q equivs
        fi
        if dod::check_uncallable dpkg-scanpackages; then
            sudo apt-get update
            sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q dpkg-dev
        fi

        # Copy declarations into temp directory
        dod_build_dir=/tmp/dod_build
        mkdir -p "$dod_build_dir"

        mapfile -t deb_srcs < <(find "$DOD_ROOT"/packages/ubuntu/sources -type f -name "*.ctl")
        for deb_src in "${deb_srcs[@]}"; do
            cp "$deb_src" "$dod_build_dir"/"$(basename "$deb_src")"
        done
        unset -v deb_srcs
        unset -v deb_src

        pushd "$dod_build_dir" > /dev/null || exit 1

        # Build metapackages
        dod::log-info "Building Ubuntu packages ..."
        mapfile -t deb_srcs < <(find . -type f -name "*.ctl")
        for deb_src in "${deb_srcs[@]}"; do
            equivs-build "$deb_src"
        done
        unset -v deb_srcs
        unset -v deb_src

        # Create repo folder and copy files
        if [[ ! -d /var/local/dotdeploy/repo ]]; then
            sudo mkdir -p /var/local/dotdeploy/repo
        fi

        mapfile -t deb_files < <(find . -type f -name "*.deb")
        for deb in "${deb_files[@]}"; do
            sudo cp "$deb" /var/local/dotdeploy/repo/"$(basename "$deb")"
        done
        unset -v deb_files
        unset -v deb

        sudo cp "$DOD_ROOT"/packages/ubuntu/dotdeploy-update-repo /usr/local/bin/dotdeploy-update-repo
        sudo chmod +x /usr/local/bin/dotdeploy-update-repo

        # Execute repo script
        sudo /usr/local/bin/dotdeploy-update-repo

        # Add repository to sources
        if [[ -f /etc/apt/sources.list.d/dotdeploy.list ]]; then
          dest_checksum=$(sha256sum /etc/apt/sources.list.d/dotdeploy.list | cut -d ' ' -f 1)
          source_checksum=$(sha256sum "$DOD_ROOT"/packages/ubuntu/dotdeploy.list | cut -d ' ' -f 1)
          if [[ $dest_checksum != "$source_checksum" ]]; then
            sudo cp -v "$DOD_ROOT"/packages/ubuntu/dotdeploy.list /etc/apt/sources.list.d/dotdeploy.list
          fi
        else
            sudo cp -v "$DOD_ROOT"/packages/ubuntu/dotdeploy.list /etc/apt/sources.list.d/dotdeploy.list
        fi

        popd > /dev/null || exit 1
        unset -v dod_build_dir

        # apt update and done
        sudo apt-get -q update
        ;;
esac
