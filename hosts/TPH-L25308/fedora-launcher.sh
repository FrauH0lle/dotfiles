#!/usr/bin/env bash

distrobox enter fedora-tph -- bash -c "exit" && \
  env -u PATH -u XDG_BIN_HOME \
  distrobox enter --additional-flags "--env HOSTPATH=$PATH" fedora-tph -nw -- bash -l
