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
#   target       - Full path where to save the file/binary
#
# Options:
#   --executable - Make the downloaded file executable
#   --extract    - Extract tar.gz archive; the binary is placed at <target>

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

    if [[ "$extract" == true ]]; then
        # Download and extract tar.gz to a temp dir, then move binary to target
        local tmp_file tmp_dir
        tmp_file="$(mktemp)"
        tmp_dir="$(mktemp -d)"
        if curl -LsSf "$url" -o "$tmp_file"; then
            if tar xzf "$tmp_file" -C "$tmp_dir"; then
                # Derive binary name from target path basename
                local binary_name
                binary_name="$(basename "$target")"

                # Locate the binary in the extracted tree
                local found
                found="$(find "$tmp_dir" -name "$binary_name" -type f | head -n 1)"
                if [[ -z "$found" ]]; then
                    dod::log-fail "Could not find '$binary_name' in extracted archive"
                    rm -rf "$tmp_file" "$tmp_dir"
                    return 1
                fi

                mv "$found" "$target"
                if [[ "$executable" == true ]]; then
                    chmod +x "$target"
                fi
                dod::log-ok "Installed to $target"
            else
                dod::log-fail "Failed to extract $asset_name"
                rm -rf "$tmp_file" "$tmp_dir"
                return 1
            fi
            rm -rf "$tmp_file" "$tmp_dir"
        else
            dod::log-fail "Failed to download $url"
            rm -rf "$tmp_file" "$tmp_dir"
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
