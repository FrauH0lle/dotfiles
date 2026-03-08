#!/usr/bin/env bash
# Manage subordinate UID/GID ranges for rootless containers
#
# Usage:
#   subid_manager.sh setup [USER]     - Find and assign available range
#   subid_manager.sh remove [USER]    - Remove entries for user
#   subid_manager.sh status [USER]    - Show current assignments
#
# Environment:
#   SUBID_START  - Starting range to search (default: 100000)
#   SUBID_COUNT  - Number of UIDs to allocate (default: 65536)

set -euo pipefail

# shellcheck source=lib.sh
source "$(dirname "$0")/lib.sh"

SUBID_START="${SUBID_START:-100000}"
SUBID_COUNT="${SUBID_COUNT:-65536}"
SUBID_FILE="/etc/subuid"
SUBGID_FILE="/etc/subgid"

# Find the next available range that doesn't overlap with existing entries
find_available_range() {
    local start="$SUBID_START"
    local count="$SUBID_COUNT"
    local end=$((start + count - 1))

    # Collect all used ranges from both files
    local used_ranges=()
    for file in "$SUBID_FILE" "$SUBGID_FILE"; do
        if [[ -f "$file" ]]; then
            while IFS=: read -r _ range_start range_count; do
                [[ -n "$range_start" && -n "$range_count" ]] || continue
                used_ranges+=("$range_start:$range_count")
            done < "$file"
        fi
    done

    # Sort ranges by start
    IFS=$'\n' sorted_ranges=($(sort -t: -k1 -n <<<"${used_ranges[*]:-}"))
    unset IFS

    # Find gap
    for range in "${sorted_ranges[@]:-}"; do
        local range_start range_end
        range_start="${range%%:*}"
        range_count="${range#*:}"
        range_end=$((range_start + range_count - 1))

        # If our desired range ends before this used range starts, we found a gap
        if (( end < range_start )); then
            break
        fi

        # If our desired range overlaps, shift past this range
        if (( start <= range_end )); then
            start=$((range_end + 1))
            end=$((start + count - 1))
        fi
    done

    echo "$start:$count"
}

# Check if user already has entries
get_user_range() {
    local user="$1"
    local file="$2"

    if [[ -f "$file" ]]; then
        grep "^${user}:" "$file" 2>/dev/null || true
    fi
}

# Setup subid/subgid for user
do_setup() {
    local user="${1:-$USER}"

    # Ensure files exist
    for file in "$SUBID_FILE" "$SUBGID_FILE"; do
        if [[ ! -f "$file" ]]; then
            sudo touch "$file"
            sudo chmod 644 "$file"
        fi
    done

    # Check existing entries
    local existing_subuid existing_subgid
    existing_subuid=$(get_user_range "$user" "$SUBID_FILE")
    existing_subgid=$(get_user_range "$user" "$SUBGID_FILE")

    if [[ -n "$existing_subuid" && -n "$existing_subgid" ]]; then
        dod::log-ok "$user already configured:"
        dod::log-info "  subuid: $existing_subuid"
        dod::log-info "  subgid: $existing_subgid"
        return 0
    fi

    # Find available range
    local range
    range=$(find_available_range)
    local range_start="${range%%:*}"
    local range_count="${range#*:}"
    local range_end=$((range_start + range_count - 1))

    dod::log-info "Assigning range $range_start-$range_end to $user"

    # Add entries using usermod (preferred) with fallback to direct file edit
    if dod::check_callable usermod && \
       sudo usermod --add-subuids "${range_start}-${range_end}" --add-subgids "${range_start}-${range_end}" "$user" 2>/dev/null; then
        :
    else
        dod::log-info "usermod unavailable or failed, editing files directly"
        echo "${user}:${range_start}:${range_count}" | sudo tee -a "$SUBID_FILE" > /dev/null
        echo "${user}:${range_start}:${range_count}" | sudo tee -a "$SUBGID_FILE" > /dev/null
    fi

    dod::log-ok "Subordinate ID range assigned successfully"
}

# Remove subid/subgid entries for user
do_remove() {
    local user="${1:-$USER}"

    local removed=false

    for file in "$SUBID_FILE" "$SUBGID_FILE"; do
        if [[ -f "$file" ]] && grep -q "^${user}:" "$file"; then
            # Use sed to remove the line - works even if user has running processes
            sudo sed -i "/^${user}:/d" "$file"
            dod::log-info "Removed $user from $file"
            removed=true
        fi
    done

    if $removed; then
        dod::log-ok "Subordinate ID ranges removed for $user"
    else
        dod::log-info "No subordinate ID ranges found for $user"
    fi
}

# Show status
do_status() {
    local user="${1:-$USER}"

    echo "Subordinate ID configuration for $user:"
    echo "  $SUBID_FILE: $(get_user_range "$user" "$SUBID_FILE" || echo "not configured")"
    echo "  $SUBGID_FILE: $(get_user_range "$user" "$SUBGID_FILE" || echo "not configured")"

    echo ""
    echo "All configured ranges:"
    for file in "$SUBID_FILE" "$SUBGID_FILE"; do
        echo "  $file:"
        if [[ -f "$file" ]]; then
            awk '{print "    " $0}' "$file"
        fi
    done
}

# Main
case "${1:-}" in
    setup)
        do_setup "${2:-}"
        ;;
    remove)
        do_remove "${2:-}"
        ;;
    status)
        do_status "${2:-}"
        ;;
    *)
        echo "Usage: $0 {setup|remove|status} [USER]"
        exit 1
        ;;
esac
