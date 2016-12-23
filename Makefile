.PHONY: backup clean help link plugins restore safe

.SILENT:

BACKUP_DIR = backup/
BACKUP_FILE = $(addprefix $(BACKUP_DIR), $(addsuffix .bak, $(FILE_NAME)))
DOT_FILE = $(addprefix ~/., $(FILE_NAME))
EXTENSION = symlink
FILE_NAME = $(basename $(notdir $<))
NODE_BIN = $(addsuffix /bin, $(NODE_DIR))
NODE_DIR = $$HOME/.n
RVM = $$HOME/.rvm/scripts/rvm
RUBY_BIN = $$HOME/.rvm/bin
RUST_BIN = $$HOME/.cargo/bin
SYMLINK_FILE = $(addprefix $(shell pwd)/, $<)

SYMLINK := $(shell find -H . -maxdepth 2 -name "*.$(EXTENSION)")
BACKUP := $(shell test -d $(BACKUP_DIR) && find -H $(BACKUP_DIR) -name "*.bak")

# Installs all dotfiles and plugins
default: link neovim plugins

# Runs backup before installing
safe: backup default

# Installs all environments
envs: node ruby rust

# Creates symbolic links
link: $(addsuffix .link, $(basename $(SYMLINK)))
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ] Linking files"

%.link: %.$(EXTENSION)
	if [ -d $(DOT_FILE) ]; then rm -rf $(DOT_FILE); fi
	ln -snf $(SYMLINK_FILE) $(DOT_FILE)

# Links the vim files to work with NeoVim
neovim:
	mkdir -p ~/.config
	ln -snf ~/.vim ~/.config/nvim
	ln -snf ~/.vimrc ~/.config/nvim/init.vim

# Makes a backup of the existing dotfiles
backup: backup_dir $(addsuffix .bak, $(basename $(SYMLINK)))
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ] Creating backup files"

backup_dir:
	mkdir -p $(BACKUP_DIR)

%.bak: %.$(EXTENSION)
	if [ -d $(BACKUP_FILE) ]; then rm -rf $(BACKUP_FILE); fi
	if [ -e $(DOT_FILE) ]; then cp -PR $(DOT_FILE) $(BACKUP_FILE); fi

# Restores the backup files
restore: $(addsuffix .res, $(basename $(BACKUP)))
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ] Restoring backup files"

%.res: %.bak
	if [ -d $(DOT_FILE) ]; then rm -rf $(DOT_FILE); fi
	cp -PR $(BACKUP_FILE) $(DOT_FILE)

# Removes the backup files
clean:
	rm -rf backup/
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ] Cleaning backup directory"

# Installs the vim plugins
plugins:
	vim -u ~/.vim/plugins.vim +PlugInstall +qa
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ] Installing vim plugins"

# Installs n with the latest version of Node.js and yarn
node:
	curl -L https://git.io/n-install | N_PREFIX=$(NODE_DIR) bash -s -- -n -y
	echo '' >> ~/.profile
	echo '# Node' >> ~/.profile
	echo 'export N_PREFIX="$(NODE_DIR)"' >> ~/.profile
	echo '[[ :$$PATH: == *":$(NODE_BIN):"* ]] || PATH+=":$(NODE_BIN)"' \
		>> ~/.profile
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ] Installing Node"

# Installs rvm with the latest version of Ruby and bundler
ruby:
	curl -sSL https://get.rvm.io | bash -s stable --ignore-dotfiles
	echo '' >> ~/.profile
	echo '# Ruby' >> ~/.profile
	echo 'export PATH="$$PATH:$(RUBY_BIN)"' >> ~/.profile
	echo '[[ -s "$(RVM)" ]] && source "$(RVM)"' >> ~/.profile
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ] Installing Ruby"

# Installs rustup with the latest version of Rust and nightly as default
rust:
	curl https://sh.rustup.rs -sSf | bash -s -- --no-modify-path \
		--default-toolchain nightly -y
	echo '' >> ~/.profile
	echo '# Rust' >> ~/.profile
	echo 'export PATH="$$PATH:$(RUST_BIN)"' >> ~/.profile
	echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ] Installing Rust"

# Shows this help message
help:
	echo "targets:"
	sed -n -e "/^[[:alpha:]]\+:/{G;s/^\(.*\):.*\n/\t\1\t/;p;d;};" \
		-e "x" Makefile | column -t -s "#"
