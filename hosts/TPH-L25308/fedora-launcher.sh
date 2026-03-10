#!/usr/bin/env bash

if [ $# -gt 0 ]; then
  distrobox enter fedora-tph -- bash -l -c "exit" && \
    env -u PATH -u XDG_BIN_HOME \
    distrobox enter --additional-flags "--env HOSTPATH=$PATH" fedora-tph  -nw -- bash -l -c "$*"
else
  distrobox enter fedora-tph -- bash -l -c "exit" && \
    env -u PATH -u XDG_BIN_HOME \
    distrobox enter --additional-flags "--env HOSTPATH=$PATH" fedora-tph -nw -- bash -l
fi
