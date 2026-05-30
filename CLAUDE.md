# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Personal tmux configuration, portable across macOS and Linux. Two real artifacts: `.tmux.conf` (the config) and `install.sh` (the bootstrap). Plugins are managed by [TPM](https://github.com/tmux-plugins/tpm), cloned on first install - they are NOT vendored in this repo.

## Common commands

```sh
./install.sh              # idempotent: backs up existing ~/.tmux.conf, symlinks this one, clones TPM if missing, runs TPM's install_plugins headlessly
tmux source ~/.tmux.conf  # reload config in a running tmux (or <prefix> r inside tmux)
shellcheck install.sh     # only shell-script lint that applies here; there is no test suite or build step
```

Inside tmux: `<prefix> I` installs plugins after editing the plugin list, `<prefix> U` updates them.

## Architecture notes

- `install.sh` is the source of truth for setup steps. The README describes its behavior - keep them in sync when changing one.
- `.tmux.conf` is symlinked into `$HOME` by `install.sh`; edits in this repo take effect on the next reload, no copy step.
- Plugin list lives at the bottom of `.tmux.conf` as `set -g @plugin '...'` lines, terminated by `run '~/.tmux/plugins/tpm/tpm'` which MUST stay last - TPM only sees plugins declared before its `run` line.
- `base-index 1` and `pane-base-index 1` are deliberate (windows/panes start at 1, matching top-row number keys). Don't "fix" these to 0.
- Terminal settings assume true-color outer terminals: `default-terminal "screen-256color"` plus a `Tc` override for `xterm-256color`. Changing these affects vim/Neovim color rendering.
- Continuum auto-restores the last session on tmux start (`@continuum-restore 'on'`), and resurrect captures pane contents and vim sessions. Behavior changes here are user-visible on every new tmux start.
- The `copy-mode-vi WheelUpPane`/`WheelDownPane` bindings exist to override tmux's default 5-lines-per-tick scroll. Don't remove them thinking they're redundant.

## Conventions

- `install.sh` runs under `set -euo pipefail`. Preserve that and quote expansions when editing.
- The script must remain idempotent - re-running it on an already-installed machine should be a no-op apart from a TPM plugin refresh.
- Comments in `.tmux.conf` document the *why* (e.g. why a binding exists, what a plugin option fixes). Match that style; don't restate what a tmux command obviously does.
- `.tmux.conf` must stay portable (macOS + Linux). Don't add OS-specific commands like `pbcopy` or `reattach-to-user-namespace`; let `tmux-yank` handle clipboard, or guard platform-specific bindings with `if-shell`.
