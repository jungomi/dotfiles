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
        default          # Installs all dotfiles and configures bash
        safe             # Runs backup before installing
        envs             # Installs all environments
        link             # Creates symbolic links
        backup           # Makes a backup of the existing dotfiles
        restore          # Restores the backup files
        clean            # Removes the backup files
        bash             # Configures Bash
        node             # Installs n and Node.js
        ruby             # Installs rvm and Ruby
        rust             # Installs rustup and Rust
        macos            # Configures MacOS
        help             # Shows this help message
```

### Patched Font

A font patched with [Nerd Fonts][nerdfonts] is required to display icons properly.

On Linux the patched version of *JetBrains Mono* is used, and on macOS a patched version of *SF Mono*.

## Integrated Tools

The following tools are either frequently used at the command line or integrated into NeoVim for
a better and more efficient workflow:

- [Fzf][fzf] - Fuzzy finder (used a lot for fuzzy file navigation in NeoVim)
- [ripgrep (rg)][ripgrep] - Faster and more intuitive grep, which respects .gitignore
- [fd][fd] - Faster and more intuitive find, which also respects .gitignore
- [bat][bat] - A *cat(1)* clone with syntax highlighting and Git integration.
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

*150% font size for better visibility in the screenshot*

![NeoVim LSP][nvim-lsp]

#### Completion

Completion with suggestions from [Language Server Protocol (LSP)][lsp], open buffers,
file paths and more, including support for snippets.

*150% font size for better visibility in the screenshot*

![NeoVim Completion][nvim-completion]

#### Debug Adapter Protocol (DAP)

Debugger using the [Debug Adapter Protocol (DAP)][dap].

*150% font size for better visibility in the screenshot*

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
