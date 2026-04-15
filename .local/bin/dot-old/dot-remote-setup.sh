#!/usr/bin/env bash
set -euo pipefail

REMOTE_URL="${1:?missing remote url}"

mkdir -p "$HOME/.local/bin"

cat > "$HOME/.local/bin/dot" <<'EOS'
#!/usr/bin/env bash
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"
EOS
chmod +x "$HOME/.local/bin/dot"

grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.zshrc" 2>/dev/null || \
  printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$HOME/.zshrc"

export PATH="$HOME/.local/bin:$PATH"

if [ ! -d "$HOME/.dotfiles" ]; then
  git clone --bare "$REMOTE_URL" "$HOME/.dotfiles"
fi

dot config --local status.showUntrackedFiles no
mkdir -p "$HOME/.dotfiles-backup"

# first checkout may fail if files already exist locally
if ! dot checkout > /tmp/dot-checkout.out 2> /tmp/dot-checkout.err; then
  awk '/^\s+\//{print $1}' /tmp/dot-checkout.err | while read -r f; do
    [ -e "$f" ] || continue
    mkdir -p "$HOME/.dotfiles-backup/$(dirname "$f")"
    mv "$f" "$HOME/.dotfiles-backup/$f"
  done
  dot checkout
fi

rm -f /tmp/dot-checkout.out /tmp/dot-checkout.err

# readonly all tracked files on non-canonical machine
dot ls-files -z | while IFS= read -r -d '' f; do
  [ -e "$HOME/$f" ] && chmod a-w "$HOME/$f" || true
done
