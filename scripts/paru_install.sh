#!/usr/bin/env bash

set -euo pipefail

# Source lib.sh for helper functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

# Ensure paru is installed
ensure_paru() {
  if dod::check_callable paru; then
    dod::log-ok "paru is already installed"
    return 0
  fi

  dod::log-info "paru not found, installing from GitHub..."

  # Check for required dependencies and install if missing
  if dod::check_uncallable git; then
    dod::log-info "git not found, installing..."
    sudo pacman -S --noconfirm git || { dod::log-fail "Failed to install git"; exit 1; }
    dod::log-ok "git installed"
  fi

  if dod::check_uncallable makepkg; then
    dod::log-info "makepkg not found, installing base-devel..."
    sudo pacman -S --noconfirm base-devel || { dod::log-fail "Failed to install base-devel"; exit 1; }
    dod::log-ok "base-devel installed"
  fi

  if dod::check_uncallable mold; then
    dod::log-info "mold not found, installing..."
    sudo pacman -S --noconfirm mold || { dod::log-fail "Failed to install mold"; exit 1; }
    dod::log-ok "mold installed"
  fi

  if dod::check_uncallable ccache; then
    dod::log-info "ccache not found, installing..."
    sudo pacman -S --noconfirm ccache || { dod::log-fail "Failed to install ccache"; exit 1; }
    dod::log-ok "ccache installed"
  fi

  # Create temporary directory
  local temp_dir
  temp_dir=$(mktemp -d)
  # trap 'rm -rf "$temp_dir"' EXIT

  dod::log-info "Cloning paru from GitHub..."
  git clone https://aur.archlinux.org/paru.git "$temp_dir/paru"

  cd "$temp_dir/paru"
  dod::log-info "Building and installing paru..."
  makepkg -si --noconfirm

  cd -
  dod::log-ok "paru installed successfully"
}

# Main function
main() {
  if [[ $# -eq 0 ]]; then
    dod::log-fail "Usage: $0 [--remove] pkg1 pkg2 opt:pkg3 opt:pkg4 ..."
    exit 1
  fi

  # Check for --remove flag
  local remove_mode=false
  if [[ $1 == "--remove" ]]; then
    remove_mode=true
    shift
  fi

  if [[ $# -eq 0 ]]; then
    dod::log-fail "No packages specified"
    exit 1
  fi

  # Ensure paru is installed
  ensure_paru

  if [[ $remove_mode == true ]]; then
    # Remove mode: uninstall packages
    local pkgs_to_remove=()

    for pkg in "$@"; do
      # Strip 'opt:' prefix if present
      if [[ $pkg == opt:* ]]; then
        pkgs_to_remove+=("${pkg#opt:}")
      else
        pkgs_to_remove+=("$pkg")
      fi
    done

    dod::log-info "Removing packages: ${pkgs_to_remove[*]}"
    paru -Rns --noconfirm "${pkgs_to_remove[@]}"
    dod::log-ok "Packages removed successfully!"
  else
    # Install mode: update system and install packages
    # Update system
    dod::log-info "Updating system with paru -Syu..."
    paru -Syu --noconfirm

    # Separate regular packages from optional packages
    local regular_pkgs=()
    local optional_pkgs=()

    for pkg in "$@"; do
      if [[ $pkg == opt:* ]]; then
        # Remove the 'opt:' prefix
        optional_pkgs+=("${pkg#opt:}")
      else
        regular_pkgs+=("$pkg")
      fi
    done

    # Install regular packages
    if [[ ${#regular_pkgs[@]} -gt 0 ]]; then
      dod::log-info "Installing regular packages: ${regular_pkgs[*]}"
      paru -S --needed --noconfirm "${regular_pkgs[@]}"
      dod::log-ok "Regular packages installed"
    fi

    # Install optional packages as dependencies
    if [[ ${#optional_pkgs[@]} -gt 0 ]]; then
      dod::log-info "Installing optional packages as dependencies: ${optional_pkgs[*]}"
      paru -S --needed --asdeps --noconfirm "${optional_pkgs[@]}"
      dod::log-ok "Optional packages installed as dependencies"
    fi

    dod::log-ok "All packages installed successfully!"
  fi
}

main "$@"
