# Dotfiles

This is a collection of my configuration files.

## Installation
```bash
git clone https://github.com/jungomi/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

`install.sh` initializes the submodules used, creates symbolic links of every
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
            install      # Installs all dotfiles and plugins
            safe         # Runs backup before installing
            backup       # Makes a backup of existing dotfiles
            link         # Creates symbolic links
            gitmodules   # Initializes git modules
            plugins      # Installs vim plugins
            clean        # Removes the backup files
```

