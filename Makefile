.PHONY: backup clean help link plugins restore safe

.SILENT:

# Some commands require bash, but by default it uses /bin/sh
SHELL := /usr/bin/env bash

ATUIN_BIN = $$HOME/.atuin/bin
BACKUP_DIR = backup/
BACKUP_DEST = $(addprefix $(BACKUP_DIR), $(CONFIG_NAME))
BOB_NVIM_BIN = $$HOME/.local/share/bob/nvim-bin
COMPLETIONS_DIR= $$HOME/.local/share/bash-completion/completions
CONFIG_DIR ?= $$HOME/.config/
CONFIG_DEST = $(addprefix $(CONFIG_DIR), $(CONFIG_NAME))
CONFIG_NAME = $(notdir $<)
MINIFORGE_BIN = $(addsuffix /bin, $(MINIFORGE_DIR))
MINIFORGE_DIR = $$HOME/miniforge3
NODE_BIN = $(addsuffix /bin, $(NODE_DIR))
NODE_DIR = $$HOME/.n
RVM = $$HOME/.rvm/scripts/rvm
RUBY_BIN = $$HOME/.rvm/bin
RUST_BIN = $$HOME/.cargo/bin

# All directories (no regular fiels) in .config/
CONFIGS := $(shell find -H $(shell pwd)/.config -mindepth 1 -maxdepth 1 -type d)
BACKUPS := $(shell test -d $(BACKUP_DIR) && find -H $(BACKUP_DIR) -mindepth 1 -maxdepth 1)

# Installs all dotfiles and configures bash
default: link bash

# Runs backup before installing
safe: backup default

# Installs all environments
envs: node python rust

# Creates symbolic links
link: config_dir $(addsuffix .link, $(CONFIGS))
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ] 🔗 Linking files"

%.link: %
	if [ -d $(CONFIG_DEST) ]; then rm -rf $(CONFIG_DEST); fi
	ln -sn $< $(CONFIG_DEST)
	echo -e "         🔗 $(CONFIG_DEST) <- $<"

config_dir:
	mkdir -p $(CONFIG_DIR)

# Makes a backup of the existing dotfiles
backup: backup_dir $(addsuffix .bak, $(CONFIGS))
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ] 💾 Creating backup files"

backup_dir:
	mkdir -p $(BACKUP_DIR)

%.bak: %
	if [ -e $(CONFIG_DEST) ]; then \
		if [ -d $(BACKUP_DEST) ]; then rm -rf $(BACKUP_DEST); fi; \
		cp -PR $(CONFIG_DEST) $(BACKUP_DEST); \
		echo -e "         💾 $(CONFIG_DEST) -> $(BACKUP_DEST)"; \
	fi

# Restores the backup files
restore: $(addsuffix .res, $(BACKUPS))
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ] 📂 Restoring backup files"

%.res: %
	if [ -d $(CONFIG_DEST) ]; then rm -rf $(CONFIG_DEST); fi
	cp -PR $(BACKUP_DEST) $(CONFIG_DEST)
	echo -e "         📂 $(CONFIG_DEST) <- $(BACKUP_DEST)"

# Removes the backup files
clean:
	rm -rf backup/
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ] 🧹 Cleaning backup directory"

# Configures Bash
bash:
	echo '' >> ~/.profile
	echo '# Bash' >> ~/.profile
	echo '[[ -f ~/.config/bash/bashrc ]] && source ~/.config/bash/bashrc' \
		>> ~/.profile
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ]  Configuring Bash"

# Installs n and Node.js
node:
	curl -L https://git.io/n-install | N_PREFIX=$(NODE_DIR) bash -s -- -n -y
	echo '' >> ~/.profile
	echo '# Node' >> ~/.profile
	echo 'export N_PREFIX="$(NODE_DIR)"' >> ~/.profile
	echo '[[ :$$PATH: == *":$(NODE_BIN):"* ]] || PATH+=":$(NODE_BIN)"' >> ~/.profile
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ] 󰎙 Installing Node"

# Installs conda (miniforge) and Python
python:
	curl -LO "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$$(uname)-$$(uname -m).sh"
	# -b stands for batch (non-interactive)
	bash Miniforge3-$$(uname)-$$(uname -m).sh -b -p $(MINIFORGE_DIR)
	rm Miniforge3-$$(uname)-$$(uname -m).sh
	echo '' >> ~/.profile
	echo '# Conda (miniforge)' >> ~/.profile
	echo 'eval "$$($(MINIFORGE_BIN)/conda shell.bash hook)"' >> ~/.profile
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ]  Installing Python"

# Installs rvm and Ruby
ruby:
	curl -sSL https://get.rvm.io | bash -s stable --ignore-dotfiles
	echo '' >> ~/.profile
	echo '# Ruby' >> ~/.profile
	echo 'export PATH="$(RUBY_BIN):$$PATH:"' >> ~/.profile
	echo '[[ -s "$(RVM)" ]] && source "$(RVM)"' >> ~/.profile
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ]  Installing Ruby"

# Installs rustup and Rust
rust:
	curl https://sh.rustup.rs -sSf | bash -s -- --no-modify-path \
		--default-toolchain stable -y
	echo '' >> ~/.profile
	echo '# Rust' >> ~/.profile
	echo 'export PATH="$(RUST_BIN):$$PATH:"' >> ~/.profile
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ]  Installing Rust"

# Subcommands for cargo that are provided as crates
cargo-subcommands:
	if cargo binstall -V &> /dev/null; then echo -e "\r\033[2K[ \033[00;32m✔\033[0m ] cargo binstall $$(cargo binstall -V) already installed"; else cargo install cargo-binstall; fi
	if cargo install-update -V &> /dev/null; then echo -e "\r\033[2K[ \033[00;32m✔\033[0m ] $$(cargo install-update -V) already installed"; else cargo install cargo-update; fi

# Installs bob and nvim
bob: cargo-subcommands
	cargo binstall -y bob-nvim
	bob use stable
	echo '' >> ~/.profile
	echo '# Bob (nvim)' >> ~/.profile
	echo 'export PATH="$(BOB_NVIM_BIN):$$PATH:"' >> ~/.profile
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ]  Installing bob and nvim"

# Configures MacOS
macos:
	./macos.sh
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ] 󰀵 Configuring MacOS"

# Various command line tools (delta, fd, rg, uv)
tools: cargo-subcommands
	command -v delta &> /dev/null || cargo binstall -y git-delta
	command -v fd &> /dev/null || cargo binstall -y fd-find
	command -v rg &> /dev/null || cargo binstall -y ripgrep
	command -v tree-sitter &> /dev/null || cargo binstall -y tree-sitter-cli
	command -v uv &> /dev/null ||  curl -LsSf https://astral.sh/uv/install.sh | sh

# Atuin for fuzzy finding shell completion
atuin:
	curl -L https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o ~/.bash-preexec.sh
	curl --proto '=https' --tlsv1.2 -LsSf https://github.com/atuinsh/atuin/releases/latest/download/atuin-installer.sh | ATUIN_NO_MODIFY_PATH=1 sh
	echo '' >> ~/.profile
	echo '# atuin' >> ~/.profile
	echo '[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh' >> ~/.profile
	echo 'export PATH="$$PATH:$(ATUIN_BIN)"' >> ~/.profile
	echo 'eval "$$(atuin init bash --disable-up-arrow)"' >> ~/.profile
	echo '# Restore the / in vim mode to do regular search rather than use atuin' >> ~/.profile
	echo '# This allows a combination to use both, which I prefer for certain situtations.' >> ~/.profile
	echo $$'bind -m vi-command \'"/": vi-search\'' >> ~/.profile
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ] Installing atuin"

# z, a smart cd
zoxide:
	curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
	echo '' >> ~/.profile
	echo '# z (smart cd)' >> ~/.profile
	echo 'eval "$$(zoxide init bash)"' >> ~/.profile

# Generate the shell completions for many installed tools
completions:
	mkdir -p $(COMPLETIONS_DIR)
	command -v atuin &> /dev/null && atuin gen-completions --shell bash > $(COMPLETIONS_DIR)/atuin
	command -v bob &> /dev/null && bob complete bash > $(COMPLETIONS_DIR)/bob
	command -v rg &> /dev/null && rg --generate complete-bash > $(COMPLETIONS_DIR)/rg
	command -v rustup &> /dev/null && rustup completions bash > $(COMPLETIONS_DIR)/rustup
	command -v rustup &> /dev/null && rustup completions bash cargo > $(COMPLETIONS_DIR)/cargo
	command -v uv &> /dev/null && uv generate-shell-completion bash > $(COMPLETIONS_DIR)/uv

# Shows this help message
help:
	echo "targets:"
	sed -n -e "/^[[:alpha:]-]\+:/{G;s/^\(.*\):.*\n/\t\1 /;p;d;};" \
		-e "x" Makefile | column -t -s "#" -o "	"
