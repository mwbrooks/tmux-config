# tmux-config

My personal tmux configuration, portable across macOS and Linux. Uses [TPM](https://github.com/tmux-plugins/tpm) to manage plugins, with a small bootstrap script to handle first-time setup on any new machine.

## Install

```sh
git clone https://github.com/mwbrooks/tmux-config ~/Development/github.com/mwbrooks/tmux-config
cd ~/Development/github.com/mwbrooks/tmux-config
./install.sh
```

The script will:

1. Back up any existing `~/.tmux.conf` and `~/.gitmux.conf` (timestamped).
2. Symlink `~/.tmux.conf` and `~/.gitmux.conf` to this repo's configs.
3. Clone TPM to `~/.tmux/plugins/tpm` if missing.
4. Install all plugins headlessly.
5. Install [`recon`](https://github.com/gavraz/recon) via `cargo install` if cargo is on `$PATH` (warns and skips otherwise).

It's idempotent — re-run any time to refresh.

## Requirements

- tmux ≥ 3.0
- git
- macOS or Linux

## Optional dependencies

The status bar uses Nerd Font glyphs and a git module. Without these, icons render as boxes and the git branch indicator stays empty - everything else still works.

- **Nerd Font** for the status bar icons. Recommended: JetBrains Mono Nerd Font.
  - macOS: `brew install --cask font-jetbrains-mono-nerd-font`
  - Linux: download from https://www.nerdfonts.com/font-downloads
  - iTerm2: Profiles -> Text -> Font -> "JetBrainsMono Nerd Font". If "Use a different font for non-ASCII text" is on, set the non-ASCII font to the same Nerd Font.
  - Ghostty: ships with JetBrains Mono Nerd Font by default.
- **gitmux** for the git branch indicator on the right of the status bar.
  - macOS/Linux: `brew install gitmux`
  - Or: `go install github.com/arl/gitmux@latest`
  - This repo ships a `.gitmux.conf` (compact `branch + flags` layout) and `install.sh` symlinks it to `~/.gitmux.conf`. Catppuccin's gitmux module hard-codes `-cfg ~/.gitmux.conf`, so the symlink is required even if you don't plan to customize.
- **[recon](https://github.com/gavraz/recon)** for the Claude Code agent dashboard (`<prefix> a`).
  - Requires the Rust toolchain (`cargo`) to build. Install via [rustup](https://rustup.rs/).
  - `install.sh` cargo-installs from a temporary fork (`mwbrooks/recon` branch `fix-discover-wrapped-claude`) that detects claude launched via wrappers like `slack claude`. Will revert to upstream once the patch lands there.

## Plugins

Managed by TPM. Install/update with `<prefix> I` / `<prefix> U` from inside tmux.

| Plugin | Purpose |
| --- | --- |
| [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) | Sensible defaults for common tmux quirks |
| [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) | Save/restore sessions: `<prefix> Ctrl-s` / `<prefix> Ctrl-r` |
| [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) | Auto-save every 15 min, auto-restore on start |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | `Ctrl-h/j/k/l` to move between vim splits and tmux panes |
| [tmux-yank](https://github.com/tmux-plugins/tmux-yank) | Cross-platform clipboard yank (pbcopy on macOS, xclip/wl-copy on Linux) |

## Key bindings

Prefix is `Ctrl-b` (tmux default).

| Keys | Action |
| --- | --- |
| `<prefix> \|` | Vertical split (in current path) |
| `<prefix> -` | Horizontal split (in current path) |
| `<prefix> h/j/k/l` | Move between panes (vim-style) |
| `Ctrl-h/j/k/l` | Move between vim splits and tmux panes seamlessly |
| `<prefix> r` | Reload `~/.tmux.conf` |
| `<prefix> a` | Open the recon Claude Code agent dashboard (popup) |
| `<prefix> I` | Install plugins |
| `<prefix> U` | Update plugins |
| `<prefix> Ctrl-s` | Save session (resurrect) |
| `<prefix> Ctrl-r` | Restore session (resurrect) |
| `v` (in copy mode) | Begin selection |
| `y` (in copy mode) | Yank to system clipboard (via tmux-yank) |
| Mouse wheel | Smooth 1-line scroll in copy mode |

## Uninstall

```sh
rm ~/.tmux.conf ~/.gitmux.conf
rm -rf ~/.tmux/plugins
```
