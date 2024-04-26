#!/usr/bin/env bash

# Packages which are absolutely required to be present before dotdeploy starts
# working.

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"/lib.sh

# equery
if dod::check_uncallable equery; then
  sudo emerge --oneshot --verbose app-portage/gentoolkit || exit 1
fi

# git
if dod::check_uncallable git; then
  sudo emerge --oneshot --verbose dev-vcs/git || exit 1
fi

# mold linker
if dod::check_uncallable mold; then
  sudo emerge --oneshot --verbose sys-devel/mold || exit 1
fi

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"/prepare_system.sh
