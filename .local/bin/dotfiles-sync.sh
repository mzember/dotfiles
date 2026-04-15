#!/bin/bash
    set -euo pipefail

# Define a function for the dotfiles command. This is more robust than an alias for scripts.
dotfiles() {
    /usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}

usage() {
    echo "Usage: $0 <command> [args]"
    echo
    echo "Commands (can be abbreviated as 'dfs-sync'):"
    echo "  push [target...] Push updates from the canonical repo."
    echo "                   Targets can be specific hosts, 'all', or 'github'."
    echo "                   With no target, pushes to 'all' and 'github'."
    echo "  fetch <host>     Fetch changes from a non-canonical machine for review."
    echo "  diff <host>      Show a diff of changes between local and a fetched host."
    exit 1
}

cmd_push() {
    local TARGET_HOSTS=()
    local PUSH_TO_GITHUB=false
    HOSTS_FILE="$HOME/.dotfiles/hosts"

    # Determine targets based on arguments
    if [ "$#" -eq 0 ]; then # Default: all hosts + github
        echo "--- Pushing updates to all hosts and GitHub ---"
        if [ -f "$HOSTS_FILE" ]; then
            mapfile -t TARGET_HOSTS < <(grep -v -e '^#' -e '^[[:space:]]*$' "$HOSTS_FILE")
        fi
        PUSH_TO_GITHUB=true
    else
        echo "--- Pushing updates to specified targets ---"
        for arg in "$@"; do
            case "$arg" in
                github)
                    PUSH_TO_GITHUB=true
                    ;;
                all)
                    if [ -f "$HOSTS_FILE" ]; then
                        # Append all hosts from the file
                        mapfile -t -O "${#TARGET_HOSTS[@]}" TARGET_HOSTS < <(grep -v -e '^#' -e '^[[:space:]]*$' "$HOSTS_FILE")
                    fi
                    ;;
                *)
                    TARGET_HOSTS+=("$arg")
                    ;;
            esac
        done
        # Remove duplicates that might arise from e.g., 'push my-vm all'
        if [ ${#TARGET_HOSTS[@]} -gt 0 ]; then
            TARGET_HOSTS=($(printf "%s\n" "${TARGET_HOSTS[@]}" | sort -u))
        fi
    fi

    if [ ${#TARGET_HOSTS[@]} -eq 0 ] && [ "$PUSH_TO_GITHUB" = false ]; then
        echo "No hosts to sync. Check your hosts file or provide a target (e.g., 'github', 'all', or a specific host)."
        exit 0
    fi

    for host in "${TARGET_HOSTS[@]}"; do
        echo "--> Syncing to host: $host"
        # 1. Push the git objects to the remote bare repository.
        dotfiles push "$host" main

        # 2. On the remote host, check for local changes before checking out the work-tree.
        # This respects the policy: "Do not overwrite local tracked changes silently".
        echo "--> Checking for and applying changes on $host..."
        if ! ssh -T "$host" <<'EOF'
set -euo pipefail

dotfiles() {
    /usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}

if [[ -n $(dotfiles status --porcelain) ]]; then
    echo "Error on host: Local modifications found. Aborting sync for this host." >&2
    dotfiles status --short >&2
    exit 1
fi

dotfiles checkout main
EOF
        then
            echo "Failed to sync host: $host. Please check the output above." >&2
        fi
    done

    # --- Process GitHub ---
    if [ "$PUSH_TO_GITHUB" = true ]; then
        echo "--> Syncing to host: github"
        if ! dotfiles remote | grep -q "^github$"; then
            echo "Warning: 'github' remote not found. Skipping." >&2
            echo "You can add it with: dotfiles remote add github https://github.com/mzember/dotfiles.git" >&2
        else
            dotfiles push github main
            echo "Pushed to github."
        fi
    fi

    echo "Push cycle complete."
}

cmd_fetch() {
    if [ "$#" -ne 1 ]; then
        echo "Error: You must specify exactly one host to fetch from." >&2
        usage
    fi
    local host="$1"
    echo "--- Fetching changes from $host ---"
    dotfiles fetch "$host"
    echo "Fetch complete. Use 'dotfiles log main..$host/main' to see changes."
}

cmd_diff() {
    if [ "$#" -ne 1 ]; then
        echo "Error: You must specify exactly one host to diff against." >&2
        usage
    fi
    local host="$1"
    echo "--- Showing diff between local 'main' and '$host/main' ---"
    echo "(Run 'dotfiles-sync fetch $host' to update the remote tracking branch first)"
    dotfiles diff "main..$host/main"
}

# --- Main command dispatcher ---
if [[ $# -eq 0 ]]; then
    usage
fi

COMMAND="$1"
shift

case "$COMMAND" in
    push)
        cmd_push "$@"
        ;;
    fetch)
        cmd_fetch "$@"
        ;;
    diff)
        cmd_diff "$@"
        ;;
    *)
        usage
        ;;
esac