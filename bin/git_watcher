#!/bin/sh

# Check for required commands
command -v git >/dev/null 2>&1 || { echo "Error: git is not installed." >&2; exit 1; }
command -v notify-send >/dev/null 2>&1 || { echo "Error: notify-send (libnotify) is not installed." >&2; exit 1; }

# Validate input
if [ $# -ne 1 ]; then
    echo "Usage: $0 /path/to/git/repository" >&2
    exit 1
fi

REPO_DIR="$1"

# Check if directory exists and is a git repo
if [ ! -d "$REPO_DIR" ]; then
    echo "Error: Directory '$REPO_DIR' does not exist" >&2
    exit 1
fi

if [ ! -d "$REPO_DIR/.git" ]; then
    echo "Error: '$REPO_DIR' is not a git repository" >&2
    exit 1
fi

# Git operations
cd "$REPO_DIR" || exit 1

# Get current branch
current_branch=$(git rev-parse --abbrev-ref HEAD)
if [ -z "$current_branch" ]; then
    echo "Error: Could not determine current branch" >&2
    exit 1
fi

# Fetch updates from remote
git fetch origin --quiet

# Compare local and remote commits
local_commit=$(git rev-parse HEAD)
remote_commit=$(git rev-parse "origin/$current_branch" 2>/dev/null)

if [ -z "$remote_commit" ]; then
    echo "Error: Remote branch 'origin/$current_branch' not found" >&2
    exit 1
fi

# Compare and notify if different
if [ "$local_commit" != "$remote_commit" ]; then
    repo_name=$(basename "$(git rev-parse --show-toplevel)")
    notify-send -h "string:desktop-entry:org.kde.konsole" -i git "Git Update Available" \
        "Repository: $repo_name\nBranch: $current_branch\n\nRemote has new commits!"
    echo "Notification sent: Updates available in origin/$current_branch"
else
    echo "Repository is up-to-date with origin/$current_branch"
fi
