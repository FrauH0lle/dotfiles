#!/usr/bin/env bash

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"/lib.sh

# Ensure that a PPA is installed
# Arguments:
#   $1 - Valid PPA address
# Outputs:
#   None. Adds PPA if necessary.
dod::ensure_ppa() {
    local ppa="$1"
    if ! grep -q "^deb .*$ppa" /etc/apt/sources.list /etc/apt/sources.list.d/* > /dev/null; then
        sudo add-apt-repository -y "ppa:$ppa" || exit 1
        sudo apt-get update
    else
        dod::log-ok "$ppa already added"
    fi
}

dod::ensure_ppa "$1"
