#!/usr/bin/env bash

# Short-circuit if common.sh has already been sourced
[[ $(type -t dod::loaded) == function ]] && return 0

# Detect if a program is installed
# Arguments:
#   $1 - Name of the program to check
# Outputs:
#   None. Exit status should be used.
dod::check_callable() {
    command -v "$1" >/dev/null
}

# Detect if a program is not installed
# Arguments:
#   $1 - Name of the program to check
# Outputs:
#   None. Exit status should be used.
dod::check_uncallable() {
    ! command -v "$1" >/dev/null
}


#
## Prettier messages

# Print info message
# Arguments:
#   $*: Message string
# Outputs:
#   Message string, prefixed with '+++' in blue and bold
dod::log-info() {
    printf "\r\033[2K\033[1;34m +++ \033[0m%s\n" "$*" >&2
}

# Print success message
# Arguments:
#   $*: Message string
# Outputs:
#   Message string, prefixed with '+++' in green and bold
dod::log-ok() {
    printf "\r\033[2K\033[1;32m +++ \033[0m%s\n" "$*" >&2
}

# Print warning message
# Arguments:
#   $*: Message string
# Outputs:
#   Message string, prefixed with '+++' in yellow and bold
dod::log-warn() {
    printf "\r\033[2K\033[1;33m +++ \033[0m%s\n" "$*" >&2
}

# Print failure message
# Arguments:
#   $*: Message string
# Outputs:
#   Message string, prefixed with '+++' in red and bold
dod::log-fail() {
    printf "\r\033[2K\033[1;31m +++ \033[0m%s\n" "$*" >&2
}


# Marker function to indicate lib.sh has been fully sourced
dod::loaded() {
  return 0
}
