# Dotfiles

This is a collection of my configuration files.

## Installation
```bash
git clone https://github.com/jungomi/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

`install.sh` initializes the submodules used, create symbolic links of every
file with the `.symlink` extension and install the vim plugins.
If a target of the linking already exists, it will ask wheter it should be
overwritten. Additionally the options `-f` or `-y` can be given to always
overwrite the existing file, or `-n` to never overwrite them.
