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

## Cheat sheet

Prefix is `Ctrl-b` (tmux default). Below, `<p>` = `Ctrl-b`.

### Sessions

| Keys / Command | Action |
| --- | --- |
| `tmux` | Start a new session (auto-numbered) |
| `tmux new -s <name>` | Start a new named session |
| `tmux ls` | List running sessions (also `tmux list-sessions`) |
| `tmux attach` | Attach to the most recent session |
| `tmux attach -t <name>` | Attach to a specific session (`-t` = target) |
| `tmux kill-session -t <name>` | Kill a session by name |
| `<p> d` | Detach (leave session running in the background) |
| `<p> s` | Session picker (interactive switch) |
| `<p> $` | Rename current session |
| `<p> Ctrl-s` | Save all sessions (tmux-resurrect) |
| `<p> Ctrl-r` | Restore last saved sessions (tmux-resurrect) |

### Windows

| Keys / Command | Action |
| --- | --- |
| `<p> c` | Create new window (in current pane's cwd) |
| `<p> ,` | Rename current window |
| `<p> &` | Kill current window (with confirm) |
| `<p> 1` … `<p> 9` | Jump to window by number |
| `<p> n` / `<p> p` | Next / previous window |
| `Alt+l` / `Alt+k` | Next window without prefix |
| `Alt+h` / `Alt+j` | Previous window without prefix |
| `<p> w` | Window picker (interactive) |
| `<p> .` | Move current window to a new index (prompts) |
| `:swap-window -t -1` / `+1` | Swap current window left / right (type at `<p> :`) |

### Panes

| Keys | Action |
| --- | --- |
| `<p> \|` | Split vertically (in current path) |
| `<p> -` | Split horizontally (in current path) |
| `<p> h/j/k/l` | Move between panes (vim-style) |
| `Ctrl-h/j/k/l` | Move between vim splits and tmux panes seamlessly |
| `<p> x` | Kill current pane (with confirm) |
| `<p> z` | Toggle zoom (full screen / restore) |
| `<p> q` | Display pane numbers briefly |
| `<p> {` / `<p> }` | Swap pane with previous / next |
| `<p> Space` | Cycle through preset layouts |
| `<p> !` | Break current pane out into its own window |

### Copy mode

| Keys | Action |
| --- | --- |
| `<p> [` | Enter copy mode |
| `q` or `Esc` | Exit copy mode |
| `v` | Begin selection (vim-style) |
| `y` | Yank selection to system clipboard (via tmux-yank) |
| `/` / `?` | Search forward / backward |
| `n` / `N` | Repeat search forward / backward |
| Mouse wheel | Smooth 1-line scroll |

### Terminal-side selection (bypasses tmux mouse mode)

When you want to drag-select text for the OS clipboard *without* entering copy mode:

| Terminal | Hold while dragging |
| --- | --- |
| iTerm2 | `Option` |
| Ghostty | `Shift` |

Release to copy to the OS clipboard via the terminal's normal selection.

### Tools

| Keys | Action |
| --- | --- |
| `<p> r` | Reload `~/.tmux.conf` |
| `<p> a` | Open the recon Claude Code agent dashboard (popup) |
| `<p> I` | Install plugins (TPM) |
| `<p> U` | Update plugins (TPM) |
| `<p> :` | Command prompt (run any tmux command) |

## Uninstall

```sh
rm ~/.tmux.conf ~/.gitmux.conf
rm -rf ~/.tmux/plugins
```
