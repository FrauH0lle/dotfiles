#!/usr/bin/env bash

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"/lib.sh

# Ensure git repository is cloned
# Arguments:
#   $1 - Valid git repository URL
#   $2 - Target folder
# Outputs:
#   None. Clones git repository if necessary.
dod::ensure_repo() {
    local repo="$1"
    local target="$2"
    if [[ ! -d $target ]]; then
        git clone --recursive "$repo" "$target"
    else
        dod::log-ok "$repo already present"
    fi
}

dod::ensure_repo "$1" "$2"
