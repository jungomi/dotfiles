# Dotfiles

This is a collection of my configuration files.

## Installation

```bash
git clone https://github.com/jungomi/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make
```

`make` initialises the submodules used, creates symbolic links of every
file with the `.symlink` extension and installs the vim plugins. If the target
of the linking already exists, it is overwritten. `make safe` provides a safer
version, which creates a backup of all existing targets, that can then be
restored with `make restore`.

```sh
$ make [targets]

  targets:
            default      # Installs all dotfiles and plugins
            safe         # Runs backup before installing
            envs         # Installs all environments
            link         # Creates symbolic links
            neovim       # Links the vim files to work with NeoVim
            backup       # Makes a backup of the existing dotfiles
            restore      # Restores the backup files
            clean        # Removes the backup files
            plugins      # Installs the vim plugins
            gitmodules   # Initialises git submodules
            node         # Installs n with the latest version of Node.js and yarn
            ruby         # Installs rvm with the latest version of Ruby and bundler
            rust         # Installs rustup with the latest version of Rust and nightly as default
            help         # Shows this help message
```

Alternatively the `install.sh` script can be used, which is interactive and will
ask whether the target of the linking should be overwritten if it already
exists. Additionally the options `-f` or `-y` can be given to always overwrite
the existing files, or `-n` to never overwrite them.

## Screenshots

### Light

![Shell light][shell-light]
![Vim light][vim-light]

### Dark

![Shell dark][shell-dark]
![Vim dark][vim-dark]

[shell-dark]: screenshots/shell-dark.png
[shell-light]: screenshots/shell-light.png
[vim-light]: screenshots/vim-light.png
[vim-dark]: screenshots/vim-dark.png
