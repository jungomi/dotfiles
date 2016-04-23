.PHONY: all backup clean gitmodules link plugins restore

BACKUP_DIR = backup/
BACKUP_FILE = $(addprefix $(BACKUP_DIR), $(addsuffix .bak, $(FILE_NAME)))
DOT_FILE = $(addprefix ~/., $(FILE_NAME))
EXTENSION = symlink
FILE_NAME = $(basename $(notdir $<))
SYMLINK_FILE = $(addprefix $(shell pwd)/, $<)

SYMLINK := $(shell find -H . -maxdepth 2 -name "*.$(EXTENSION)")
BACKUP := $(shell [[ -d $(BACKUP_DIR) ]] && find -H $(BACKUP_DIR) -name "*.bak")

all: link gitmodules plugins

safe: backup all

link: $(addsuffix .link, $(basename $(SYMLINK)))
	@echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ] Linking files"

%.link: %.$(EXTENSION)
	@if [ -d $(DOT_FILE) ]; then rm -rf $(DOT_FILE); fi
	ln -snf $(SYMLINK_FILE) $(DOT_FILE)

backup: backup_dir $(addsuffix .bak, $(basename $(SYMLINK)))
	@echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ] Creating backup files"

backup_dir:
	mkdir -p $(BACKUP_DIR)

%.bak: %.$(EXTENSION)
	@if [ -d $(BACKUP_FILE) ]; then rm -rf $(BACKUP_FILE); fi
	cp -PR $(DOT_FILE) $(BACKUP_FILE)

restore: $(addsuffix .res, $(basename $(BACKUP)))
	@echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ] Restoring backup files"

%.res: %.bak
	@if [ -d $(DOT_FILE) ]; then rm -rf $(DOT_FILE); fi
	cp -PR $(BACKUP_FILE) $(DOT_FILE)

plugins:
	vim -u ~/.vim/plugins.vim +PlugInstall +qa
	@echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ] Installing vim plugins"

gitmodules:
	git submodule update --init
	@echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ] Initialising git modules"

clean:
	rm -rf backup/
	@echo -e "\r\033[2K[ \033[00;32mDONE\033[0m ] Cleaning backup directory"
