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
#   download_github install <repo> <asset_name> <target_path> [options]
#   download_github update <repo> <asset_name> <target_path> [options]
#
# Arguments:
#   install      - Download only if target doesn't exist
#   update       - Always download (overwrite if exists)
#   repo         - GitHub repository in format "owner/repo"
#   asset_name   - Name of the release asset to download
#   target       - Full path where to save the file (or directory if --extract)
#
# Options:
#   --executable - Make the downloaded file executable
#   --extract    - Extract tar.gz archive to target directory

dod::download_github() {
    local subcommand="$1"
    local repo="$2"
    local asset_name="$3"
    local target="$4"
    local executable=false
    local extract=false

    # Parse optional flags
    shift 4 2>/dev/null || shift $#
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --executable) executable=true ;;
            --extract) extract=true ;;
        esac
        shift
    done

    local url="https://github.com/${repo}/releases/latest/download/${asset_name}"

    case "$subcommand" in
        install)
            if [[ "$extract" == true ]]; then
                # For extracted archives, check if binary exists in target dir
                local binary_name="${asset_name%%.tar.gz*}"
                if [[ -f "$target/$binary_name" ]]; then
                    dod::log-ok "$target/$binary_name already present"
                    return 0
                fi
            elif [[ -f "$target" ]]; then
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
    if [[ "$extract" == true ]]; then
        mkdir -p "$target"
    fi

    dod::log-info "Downloading $asset_name from $repo..."

    if [[ "$extract" == true ]]; then
        # Download and extract tar.gz
        local tmp_file
        tmp_file="$(mktemp)"
        if curl -LsSf "$url" -o "$tmp_file"; then
            if tar xzf "$tmp_file" -C "$target"; then
                dod::log-ok "Extracted to $target"
                if [[ "$executable" == true ]]; then
                    # Make all extracted files executable
                    find "$target" -type f -exec chmod +x {} \;
                fi
            else
                dod::log-fail "Failed to extract $asset_name"
                rm -f "$tmp_file"
                return 1
            fi
            rm -f "$tmp_file"
        else
            dod::log-fail "Failed to download $url"
            rm -f "$tmp_file"
            return 1
        fi
    else
        # Direct download
        if curl -LsSf "$url" -o "$target"; then
            dod::log-ok "Downloaded to $target"
            if [[ "$executable" == true ]]; then
                chmod +x "$target"
            fi
        else
            dod::log-fail "Failed to download $url"
            return 1
        fi
    fi
}

dod::download_github "$@"
