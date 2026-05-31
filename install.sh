#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TPM_DIR="$HOME/.tmux/plugins/tpm"

if ! command -v tmux >/dev/null 2>&1; then
  echo "Error: tmux is not installed. Install it first (e.g. 'brew install tmux' or 'apt install tmux')." >&2
  exit 1
fi

# Symlink each tracked dotfile into $HOME, backing up any pre-existing real file.
link_dotfile() {
  local src="$1" dest="$2"
  if [ -e "$dest" ] && [ "$(readlink "$dest" || true)" != "$src" ]; then
    local backup="$dest.backup-$(date +%Y%m%d%H%M%S)"
    echo "Backing up existing $dest -> $backup"
    mv "$dest" "$backup"
  fi
  echo "Linking $dest -> $src"
  ln -sf "$src" "$dest"
}

link_dotfile "$REPO_DIR/.tmux.conf"   "$HOME/.tmux.conf"
link_dotfile "$REPO_DIR/.gitmux.conf" "$HOME/.gitmux.conf"

if [ ! -d "$TPM_DIR" ]; then
  echo "Cloning TPM into $TPM_DIR"
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  echo "TPM already present at $TPM_DIR"
fi

echo "Installing plugins via TPM..."
"$TPM_DIR/bin/install_plugins"

echo
echo "Done. Start tmux, or if it's already running, reload with: <prefix> r"
