#!/usr/bin/env bash

# Exit on error
set -e
# Exit on unset variable
set -u
# Exit on errors in pipes
set -o pipefail
# Inherit ERR traps
set -E

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"/lib.sh

# Download files from GitHub releases
#
# Usage:
#   download_github install <repo> <asset_name> <target_path> [--executable]
#   download_github update <repo> <asset_name> <target_path> [--executable]
#
# Arguments:
#   install    - Download only if target doesn't exist
#   update     - Always download (overwrite if exists)
#   repo       - GitHub repository in format "owner/repo"
#   asset_name - Name of the release asset to download
#   target     - Full path where to save the downloaded file
#   --executable - Make the downloaded file executable (optional)

dod::download_github() {
    local subcommand="$1"
    local repo="$2"
    local asset_name="$3"
    local target="$4"
    local executable=false

    # Parse optional --executable flag
    shift 4 2>/dev/null || shift $#
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --executable) executable=true ;;
        esac
        shift
    done

    local url="https://github.com/${repo}/releases/latest/download/${asset_name}"

    case "$subcommand" in
        install)
            if [[ -f "$target" ]]; then
                dod::log-ok "$target already present"
                return 0
            fi
            ;;
        update)
            : # Always proceed with download
            ;;
        *)
            dod::log-fail "Unknown subcommand: $subcommand (use 'install' or 'update')"
            return 1
            ;;
    esac

    # Create parent directory if needed
    mkdir -p "$(dirname "$target")"

    dod::log-info "Downloading $asset_name from $repo..."
    if curl -LsSf "$url" -o "$target"; then
        dod::log-ok "Downloaded to $target"
        if [[ "$executable" == true ]]; then
            chmod +x "$target"
        fi
    else
        dod::log-fail "Failed to download $url"
        return 1
    fi
}

dod::download_github "$@"
