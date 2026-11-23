# Dotfiles

This is a collection of my configuration files.

Initially, I tried having a config that can be used for both Vim and [NeoVim][neovim] but with
the release of NeoVim 0.5, which added Lua support and a native LSP client, I decided to drop
the old Vim compatibility and create a NeoVim config based on Lua. Wherever possible, I tried to
use as many Lua plugins as possible over VimScript ones, because those either try to support old
versions of Vim or potentially not use newer features.

## Installation

```bash
git clone https://github.com/jungomi/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make
```

`make` creates symbolic links of every directory in the `.config/` directory to `~/.config/`.
If the target of the linking already exists, it is overwritten.
`make safe` provides a safer version, which creates a backup of all existing targets, that can then
be restored with `make restore`.

```sh
$ make [targets]

  targets:
          default              Installs all dotfiles and configures bash
          safe                 Runs backup before installing
          envs                 Installs all environments
          link                 Creates symbolic links
          backup               Makes a backup of the existing dotfiles
          restore              Restores the backup files
          clean                Removes the backup files
          bash                 Configures Bash
          node                 Installs n and Node.js
          python               Installs conda (miniforge) and Python
          ruby                 Installs rvm and Ruby
          rust                 Installs rustup and Rust
          cargo-subcommands    Subcommands for cargo that are provided as crates
          bob                  Installs bob and nvim
          bun                  Install bun
          uv                   Install uv
          worktrunk            Install wt (worktrunk)
          macos                Configures MacOS
          tools                Various command line tools (delta, fd, rg, uv)
          atuin                Atuin for fuzzy finding shell completion
          zoxide               z, a smart cd
          completions          Generate the shell completions for many installed tools
          help                 Shows this help message
```

### Patched Font

A font patched with [Nerd Fonts][nerdfonts] is required to display icons properly.

On Linux the patched version of _JetBrains Mono_ is used, and on macOS a patched version of _SF Mono_.

## Integrated Tools

The following tools are either frequently used at the command line or integrated into NeoVim for
a better and more efficient workflow:

- [Fzf][fzf] - Fuzzy finder (used a lot for fuzzy file navigation in NeoVim)
- [ripgrep (rg)][ripgrep] - Faster and more intuitive grep, which respects .gitignore
- [fd][fd] - Faster and more intuitive find, which also respects .gitignore
- [bat][bat] - A _cat(1)_ clone with syntax highlighting and Git integration.
- [delta][delta] - Viewer for (git) diffs with syntax highlighting and side-by-side views

## Screenshots

### Shell + Tmux + Git

The git diff is displayed using [Delta][delta]

Tmux icons:

- 🔎 = A pane is maximized (zoomed) in that window.
- 🔗 = Panes are synchronised, i.e. all are focused and receive the same inputs.

![Shell + Tmux + Git][shell-tmux-git]

### NeoVim

#### Language Server Protocol (LSP)

[Language Server Protocol (LSP)][lsp] integration for diagnostics and other language actions,
such as formatting, signature help, type hints etc.

_150% font size for better visibility in the screenshot_

![NeoVim LSP][nvim-lsp]

#### Completion

Completion with suggestions from [Language Server Protocol (LSP)][lsp], open buffers,
file paths and more, including support for snippets.

_150% font size for better visibility in the screenshot_

![NeoVim Completion][nvim-completion]

#### Debug Adapter Protocol (DAP)

Debugger using the [Debug Adapter Protocol (DAP)][dap].

_150% font size for better visibility in the screenshot_

![NeoVim DAP][nvim-dap]

[bat]: https://github.com/sharkdp/bat
[dap]: https://microsoft.github.io/debug-adapter-protocol/
[delta]: https://github.com/dandavison/delta
[fd]: https://github.com/sharkdp/fd
[fzf]: https://github.com/junegunn/fzf
[neovim]: https://neovim.io/
[nerdfonts]: https://www.nerdfonts.com/
[nvim-completion]: .github/screenshots/nvim-completion.png
[nvim-dap]: .github/screenshots/nvim-dap.png
[nvim-lsp]: .github/screenshots/nvim-lsp.png
[lsp]: https://microsoft.github.io/language-server-protocol/
[ripgrep]: https://github.com/BurntSushi/ripgrep
[shell-tmux-git]: .github/screenshots/shell-tmux-git.png
