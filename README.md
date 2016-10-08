# Dotfiles

This is a collection of my configuration files.

## Installation

```bash
git clone https://github.com/jungomi/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

`install.sh` initialises the submodules used, creates symbolic links of every
file with the `.symlink` extension and installs the vim plugins.
If a target of the linking already exists, it will ask whether it should be
overwritten. Additionally the options `-f` or `-y` can be given to always
overwrite the existing file, or `-n` to never overwrite them.

`make` can be used in place of `install.sh`. The Makefile does not support
interactive input (i.e. files will always be overwritten and are lost if no
backup was made).

```bash
$ make [targets]

  targets:
            default      # Installs all dotfiles and plugins
            safe         # Runs backup before installing
            link         # Creates symbolic links
            backup       # Makes a backup of the existing dotfiles
            restore      # Restores the backup files
            clean        # Removes the backup files
            plugins      # Installs the vim plugins
            gitmodules   # Initialises git submodules
            help         # Shows this help message
```

## Screenshots

### Light

![Shell light][shell-light]
![Vim light][vim-light]

### Dark

![Shell dark][shell-dark]
![Vim dark][vim-dark]

[shell-dark]: media/screenshot-shell-dark.png
[shell-light]: media/screenshot-shell-light.png
[vim-light]: media/screenshot-vim-light.png
[vim-dark]: media/screenshot-vim-dark.png
