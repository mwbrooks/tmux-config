#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF_SRC="$REPO_DIR/.tmux.conf"
CONF_DEST="$HOME/.tmux.conf"
TPM_DIR="$HOME/.tmux/plugins/tpm"

if ! command -v tmux >/dev/null 2>&1; then
  echo "Error: tmux is not installed. Install it first (e.g. 'brew install tmux' or 'apt install tmux')." >&2
  exit 1
fi

if [ -e "$CONF_DEST" ] && [ "$(readlink "$CONF_DEST" || true)" != "$CONF_SRC" ]; then
  backup="$CONF_DEST.backup-$(date +%Y%m%d%H%M%S)"
  echo "Backing up existing $CONF_DEST -> $backup"
  mv "$CONF_DEST" "$backup"
fi

echo "Linking $CONF_DEST -> $CONF_SRC"
ln -sf "$CONF_SRC" "$CONF_DEST"

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
