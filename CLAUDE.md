# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Personal tmux configuration, portable across macOS and Linux. Three tracked artifacts: `.tmux.conf` (the tmux config), `.gitmux.conf` (gitmux status-bar config, consumed by the external `arl/gitmux` binary), and `install.sh` (the bootstrap). Both `.conf` files get symlinked into `$HOME` by `install.sh`. Plugins are managed by [TPM](https://github.com/tmux-plugins/tpm), cloned on first install - they are NOT vendored in this repo.

## Common commands

```sh
./install.sh              # idempotent: backs up existing ~/.tmux.conf, symlinks this one, clones TPM if missing, runs TPM's install_plugins headlessly
tmux source ~/.tmux.conf  # reload config in a running tmux (or <prefix> r inside tmux)
shellcheck install.sh     # only shell-script lint that applies here; there is no test suite or build step
```

Inside tmux: `<prefix> I` installs plugins after editing the plugin list, `<prefix> U` updates them.

## Architecture notes

- `install.sh` is the source of truth for setup steps. The README describes its behavior - keep them in sync when changing one.
- `.tmux.conf` and `.gitmux.conf` are symlinked into `$HOME` by `install.sh`; edits in this repo take effect on the next reload, no copy step. Catppuccin's gitmux module hard-codes `-cfg ~/.gitmux.conf`, so the symlink is required even if the user doesn't customize it.
- Plugin list lives at the bottom of `.tmux.conf` as `set -g @plugin '...'` lines, terminated by `run '~/.tmux/plugins/tpm/tpm'` which MUST stay last - TPM only sees plugins declared before its `run` line.
- Catppuccin options (`@catppuccin_flavour`, status colors, etc.) MUST be set BEFORE the `run '...tpm'` line. Set them after and the theme silently falls back to defaults.
- `base-index 1` and `pane-base-index 1` are deliberate (windows/panes start at 1, matching top-row number keys). Don't "fix" these to 0.
- Terminal settings assume true-color outer terminals: `default-terminal "screen-256color"` plus a `Tc` override for `xterm-256color`. Changing these affects vim/Neovim color rendering.
- The Claude Code block (`allow-passthrough on`, `extended-keys on`, `terminal-features 'xterm*:extkeys'`) is required for Claude Code progress notifications and Shift+Enter-to-newline. Don't remove without checking https://code.claude.com/docs/en/terminal-config.
- Continuum auto-restores the last session on tmux start (`@continuum-restore 'on'`), and resurrect captures pane contents and vim sessions. Behavior changes here are user-visible on every new tmux start.
- The `copy-mode-vi WheelUpPane`/`WheelDownPane` bindings exist to override tmux's default 5-lines-per-tick scroll. Don't remove them thinking they're redundant.

## Conventions

- `install.sh` runs under `set -euo pipefail`. Preserve that and quote expansions when editing.
- The script must remain idempotent - re-running it on an already-installed machine should be a no-op apart from a TPM plugin refresh.
- Comments in `.tmux.conf` document the *why* (e.g. why a binding exists, what a plugin option fixes). Match that style; don't restate what a tmux command obviously does.
- `.tmux.conf` must stay portable (macOS + Linux). Don't add OS-specific commands like `pbcopy` or `reattach-to-user-namespace`; let `tmux-yank` handle clipboard, or guard platform-specific bindings with `if-shell`.
