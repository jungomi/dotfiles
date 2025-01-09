.PHONY: backup clean help link plugins restore safe

.SILENT:

BACKUP_DIR = backup/
BACKUP_DEST = $(addprefix $(BACKUP_DIR), $(CONFIG_NAME))
BOB_NVIM_BIN = $$HOME/.local/share/bob/nvim-bin
CONFIG_DIR ?= $$HOME/.config/
CONFIG_DEST = $(addprefix $(CONFIG_DIR), $(CONFIG_NAME))
CONFIG_NAME = $(notdir $<)
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
envs: node ruby rust

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
	echo '[[ :$$PATH: == *":$(NODE_BIN):"* ]] || PATH+=":$(NODE_BIN)"' \
		>> ~/.profile
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ] 󰎙 Installing Node"

# Installs rvm and Ruby
ruby:
	curl -sSL https://get.rvm.io | bash -s stable --ignore-dotfiles
	echo '' >> ~/.profile
	echo '# Ruby' >> ~/.profile
	echo 'export PATH="$$PATH:$(RUBY_BIN)"' >> ~/.profile
	echo '[[ -s "$(RVM)" ]] && source "$(RVM)"' >> ~/.profile
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ]  Installing Ruby"

# Installs rustup and Rust
rust:
	curl https://sh.rustup.rs -sSf | bash -s -- --no-modify-path \
		--default-toolchain stable -y
	echo '' >> ~/.profile
	echo '# Rust' >> ~/.profile
	echo 'export PATH="$$PATH:$(RUST_BIN)"' >> ~/.profile
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ]  Installing Rust"

# Subcommands for cargo that are provided as crates
cargo-subcommands:
	if cargo binstall -V &> /dev/null; then echo -e "\r\033[2K[ \033[00;32m✔\033[0m ] cargo binstall $$(cargo binstall -V) already installed"; else cargo install cargo-binstall; fi
	if cargo install-update -V &> /dev/null; then echo -e "\r\033[2K[ \033[00;32m✔\033[0m ] $$(cargo install-update -V) already installed"; else cargo install cargo-update; fi

# Installs bob and nvim
bob: cargo-subcommands
	cargo binstall bob-nvim
	bob use stable
	echo '' >> ~/.profile
	echo '# Bob (nvim)' >> ~/.profile
	echo 'export PATH="$$PATH:$(BOB_NVIM_BIN)"' >> ~/.profile
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ]  Installing bob and nvim"

# Configures MacOS
macos:
	./macos.sh
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ] 󰀵 Configuring MacOS"

# Various command line tools (atuin, delta, rg, uv, z)
tools: cargo-subcommands atuin zoxide
	command -v delta &> /dev/null || cargo binstall git-delta
	command -v rg &> /dev/null || cargo binstall ripgrep
	command -v uv &> /dev/null ||  curl -LsSf https://astral.sh/uv/install.sh | sh

# Atuin for fuzzy finding shell completion
atuin:
	curl -L https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o ~/.bash-preexec.sh
	curl --proto '=https' --tlsv1.2 -LsSf https://github.com/atuinsh/atuin/releases/latest/download/atuin-installer.sh | ATUIN_NO_MODIFY_PATH=1 sh
	echo '' >> ~/.profile
	echo '# atuin' >> ~/.profile
	echo '[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh' >> ~/.profile
	echo '. "$$HOME/.atuin/bin/env"' >> ~/.profile
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

# Shows this help message
help:
	echo "targets:"
	sed -n -e "/^[[:alpha:]]\+:/{G;s/^\(.*\):.*\n/\t\1\t/;p;d;};" \
		-e "x" Makefile | column -t -s "#" -o "	"
