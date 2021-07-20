.PHONY: backup clean help link plugins restore safe

.SILENT:

BACKUP_DIR = backup/
BACKUP_DEST = $(addprefix $(BACKUP_DIR), $(CONFIG_NAME))
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

# Installs all dotfiles and plugins
default: link bash neovim plugins

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

# Links the vim files to work with NeoVim
neovim:
	mkdir -p ~/.config
	ln -snf ~/.vim ~/.config/nvim
	ln -snf ~/.vimrc ~/.config/nvim/init.vim

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

# Installs the vim plugins
plugins:
	nvim -u ~/.vim/plugins.vim +PlugInstall +qa
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ]  Installing vim plugins"

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
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ]  Installing Node"

# Installs rvm and Ruby
ruby:
	curl -sSL https://get.rvm.io | bash -s stable --ignore-dotfiles
	echo '' >> ~/.profile
	echo '# Ruby' >> ~/.profile
	echo 'export PATH="$$PATH:$(RUBY_BIN)"' >> ~/.profile
	echo '[[ -s "$(RVM)" ]] && source "$(RVM)"' >> ~/.profile
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ]  Installing Ruby"

# Installs rustup and Rust nightly
rust:
	curl https://sh.rustup.rs -sSf | bash -s -- --no-modify-path \
		--default-toolchain nightly -y
	echo '' >> ~/.profile
	echo '# Rust' >> ~/.profile
	echo 'export PATH="$$PATH:$(RUST_BIN)"' >> ~/.profile
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ]  Installing Rust"

# Configures MacOS
macos:
	./macos.sh
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ]  Configuring MacOS"

# Shows this help message
help:
	echo "targets:"
	sed -n -e "/^[[:alpha:]]\+:/{G;s/^\(.*\):.*\n/\t\1\t/;p;d;};" \
		-e "x" Makefile | column -t -s "#" -o "	"
