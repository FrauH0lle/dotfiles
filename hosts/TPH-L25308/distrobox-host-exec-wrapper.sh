#!/usr/bin/env bash

# Wrapper for distrobox-host-exec that adjusts PATH for host commands.
#
# This ensures commands executed on the host use correct PATH.
#
# QUOTING EXPLANATION:
#   We cannot use "$@" inside double quotes because it breaks out of the quoting
#   context. For example, with args 'echo "hello world"':
#     "PATH=\"$PATH\" \"$@\""  →  "PATH=\"/path\" "echo" "hello world""
#   This produces mismatched quotes and syntax errors.
#
#   The solution: pass "$@" as separate arguments to 'sh -c' after a placeholder.
#   Inside the command string, escaped \"\$@\" is interpreted by the inner shell:
#     sh -c "PATH=\"$HOSTPATH\" \"\$@\"" _ echo "hello world"
#   - The '_' becomes $0 inside sh -c (a conventional shell name placeholder)
#   - 'echo' and 'hello world' become $1, $2, etc.
#   - "$@" inside sh -c expands to those arguments properly quoted

# Pass through options that don't need PATH wrapping
case "$1" in
    -h|--help|-V|--version)
        exec /usr/sbin/distrobox-host-exec "$@"
        ;;
esac

# Parse options that can precede a command
opts=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        -v|--verbose)
            opts+=("$1")
            shift
            ;;
        -Y|--yes)
            opts+=("$1")
            shift
            ;;
        --)
            shift
            break
            ;;
        -*)
            # Unknown option - pass through to original for error handling
            exec /usr/sbin/distrobox-host-exec "$@"
            ;;
        *)
            # First non-option argument - this is the command
            break
            ;;
    esac
done

# Execute with PATH wrapper
exec /usr/sbin/distrobox-host-exec "${opts[@]}" sh -c "PATH=\"$HOSTPATH\" \"\$@\"" _ "$@"
