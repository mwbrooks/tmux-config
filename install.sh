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

# recon: tmux-native dashboard for Claude Code agents (https://github.com/gavraz/recon).
# Installed via cargo because upstream releases ship no prebuilt binaries.
# TODO: switch back to gavraz/recon once mwbrooks/recon's wrapper-discovery fix lands upstream.
# The fork patches find_claude_child_pid() to walk descendants so claude launched via wrappers
# like `slack claude` (bash -> deno -> claude) is detected, not just direct children.
RECON_GIT="https://github.com/mwbrooks/recon"
RECON_BRANCH="fix-discover-wrapped-claude"
if ! command -v cargo >/dev/null 2>&1; then
  echo "Warning: cargo not found - skipping recon install. Install Rust (https://rustup.rs) and re-run." >&2
elif ! command -v recon >/dev/null 2>&1; then
  echo "Installing recon via cargo..."
  cargo install --git "$RECON_GIT" --branch "$RECON_BRANCH" --locked
else
  echo "recon already present at $(command -v recon)"
fi

echo
echo "Done. Start tmux, or if it's already running, reload with: <prefix> r"
